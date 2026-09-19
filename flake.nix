{
  description = "Typst Resume Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      flake.lib = {
        buildCv =
          { pkgs, cvYaml }:
          pkgs.stdenv.mkDerivation {
            pname = "curriculum-vitae";
            version = "1.0.0";
            src = ./.;

            nativeBuildInputs = [ pkgs.typst ];

            buildPhase = ''
              mkdir -p data
              cp -f ${cvYaml} data/cv.yaml
              typst compile --root . resumes/en/resume.typ resume.pdf
              typst compile --root . resumes/pt-br/curriculo.typ curriculo.pdf
            '';

            installPhase = ''
              mkdir -p $out/resumes/en $out/resumes/pt-br
              cp resume.pdf $out/
              cp resume.pdf $out/resumes/en/
              cp curriculo.pdf $out/
              cp curriculo.pdf $out/resumes/pt-br/
            '';
          };
      };

      perSystem =
        { pkgs, ... }:
        {
          packages.default = pkgs.stdenv.mkDerivation {
            pname = "resume-template";
            version = "1.0.0";
            src = ./.;
            installPhase = ''
              mkdir -p $out
              cp -r template.typ resumes $out/
            '';
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              typst
              typstyle
              tinymist
            ];
          };
        };
    };
}
