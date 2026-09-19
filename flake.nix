{
  description = "Curriculum Vitae (Typst / Nix)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    cv-data = {
      url = "git+file:./submodules/cv-data";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };
  };

  outputs =
    inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      perSystem =
        { pkgs, ... }:
        let
          cvPdf = pkgs.stdenv.mkDerivation {
            pname = "curriculum-vitae";
            version = "1.0.0";
            src = ./.;

            nativeBuildInputs = [ pkgs.typst ];

            buildPhase = ''
              mkdir -p data
              cp -f ${inputs.cv-data}/cv.yaml data/cv.yaml
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
        in
        {
          packages = {
            default = cvPdf;
            cv = cvPdf;
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
