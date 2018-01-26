{ pkgs }:

pkgs.buildEnv {
  name = "scala-tools";
  paths = with pkgs; [
    ammonite
    jdk8
    protobuf2_5
    sbt
    scalafmt
  ];
}
