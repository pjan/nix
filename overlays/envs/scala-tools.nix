{ pkgs }:

pkgs.buildEnv {
  name = "scala-tools";
  paths = with pkgs; [
    jdk8
    protobuf2_5
    sbt
    fira-code
  ];
}
