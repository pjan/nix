{ pkgs }:

with (import ./lib/directory.nix { inherit pkgs; });

let
  # Kernel generators.
  kernels = pkgs.callPackage ./kernels {};
  kernelsString = pkgs.lib.concatMapStringsSep ":" (k: "${k.spec}");

  # Python version setup.
  python3 = pkgs.python3Packages;

  # Default configuration.
  defaultDirectory = "${python3.jupyterlab}/share/jupyter/lab";
  defaultKernels = [ (kernels.iPythonWith {}) ];
  defaultExtraPackages = p: [];
  defaultExtraInputsFrom = p: [];

  jupyter_contrib_core = python3.buildPythonPackage rec {
    pname = "jupyter_contrib_core";
    version = "0.3.3";

    src = python3.fetchPypi {
      inherit pname version;
      sha256 = "e65bc0e932ff31801003cef160a4665f2812efe26a53801925a634735e9a5794";
    };
    doCheck = false;  # too much
    propagatedBuildInputs = [
      python3.traitlets
      python3.notebook
      python3.tornado
      ];
  };

  jupyter_nbextensions_configurator = python3.buildPythonPackage rec {
    pname = "jupyter_nbextensions_configurator";
    version = "0.4.1";

    src = python3.fetchPypi {
      inherit pname version;
      sha256 = "e5e86b5d9d898e1ffb30ebb08e4ad8696999f798fef3ff3262d7b999076e4e83";
    };

    propagatedBuildInputs = [
      jupyter_contrib_core
      python3.pyyaml
      ];

    doCheck = false;  # too much
  };

  # JupyterLab with the appropriate kernel and directory setup.
  jupyterlabWith = {
    directory ? defaultDirectory,
    kernels ? defaultKernels,
    extraPackages ? defaultExtraPackages,
    extraInputsFrom ? defaultExtraInputsFrom,
    extraJupyterPath ? _: ""
    }:
    let
      # PYTHONPATH setup for JupyterLab
      pythonPath = python3.makePythonPath [
        python3.ipykernel
        jupyter_contrib_core
        jupyter_nbextensions_configurator
        python3.tornado
      ];

      # JupyterLab executable wrapped with suitable environment variables.
      jupyterlab = python3.toPythonModule (
        python3.jupyterlab.overridePythonAttrs (oldAttrs: {
          makeWrapperArgs = [
            "--set JUPYTERLAB_DIR ${directory}"
            "--set JUPYTER_PATH ${extraJupyterPath pkgs}:${kernelsString kernels}"
            "--set PYTHONPATH ${extraJupyterPath pkgs}:${pythonPath}"
          ];
        })
      );

      # Shell with the appropriate JupyterLab, launching it at startup.
      env = pkgs.mkShell {
        name = "jupyterlab-shell";
        inputsFrom = extraInputsFrom pkgs;
        buildInputs =
          [ jupyterlab generateDirectory generateLockFile pkgs.nodejs ] ++
          (map (k: k.runtimePackages) kernels) ++
          (extraPackages pkgs);
        shellHook = ''
          export JUPYTER_PATH=${kernelsString kernels}
          export JUPYTERLAB=${jupyterlab}
        '';
      };
    in
      jupyterlab.override (oldAttrs: {
        passthru = oldAttrs.passthru or {} // { inherit env; };
      });
in
  { inherit
      jupyterlabWith
      kernels;
  }
