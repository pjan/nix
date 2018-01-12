{ bundlerEnv, lib, ruby }:

bundlerEnv rec {
  name = "ghi-${version}";
  version = "1.2.0";

  inherit ruby;
  gemdir = ./.;

  meta = with lib; {
    description = "GitHub Issues on the command line.";
    homepage    = https://github.com/stephencelis/ghi;
    license     = licenses.mit;
    maintainers = [ "Pjan Vandaele <pjan.vandaele@gmai.com>" ];
    platforms   = platforms.unix;
  };
}
