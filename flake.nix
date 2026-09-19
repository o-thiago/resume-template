{
  description = "Thiago Macedo Mendes - Curriculum Vitae (Typst / Nix)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    cv-data = {
      url = "git+file:///home/rika/Programming/cv-data";
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
          buildCv =
            { name, srcDir }:
            pkgs.stdenv.mkDerivation {
              pname = "cv-${name}";
              version = "1.0.0";
              src = ./.;

              nativeBuildInputs = [ pkgs.typst ];

              buildPhase = ''
                mkdir -p data
                cp -f ${inputs.cv-data}/cv.yaml data/cv.yaml
                if [ -f ${inputs.cv-data}/cv.schema.json ]; then
                  cp -f ${inputs.cv-data}/cv.schema.json data/cv.schema.json
                fi
                typst compile --root . resumes/${srcDir}/${name}.typ ${name}.pdf
              '';

              installPhase = ''
                mkdir -p $out
                cp ${name}.pdf $out/
              '';
            };

          cv-en = buildCv {
            name = "resume";
            srcDir = "en";
          };

          cv-pt = buildCv {
            name = "curriculo";
            srcDir = "pt-br";
          };

          cv-all = pkgs.stdenv.mkDerivation {
            pname = "curriculum-vitae";
            version = "1.0.0";
            src = ./.;

            nativeBuildInputs = [ pkgs.typst ];

            buildPhase = ''
              mkdir -p data
              cp -f ${inputs.cv-data}/cv.yaml data/cv.yaml
              if [ -f ${inputs.cv-data}/cv.schema.json ]; then
                cp -f ${inputs.cv-data}/cv.schema.json data/cv.schema.json
              fi
              typst compile --root . resumes/en/resume.typ resume.pdf
              typst compile --root . resumes/pt-br/curriculo.typ curriculo.pdf
            '';

            installPhase = ''
              mkdir -p $out/resumes/en $out/resumes/pt-br
              cp -r resumes $out/
              cp resume.pdf $out/resume.pdf
              cp resume.pdf $out/resumes/en/resume.pdf
              cp curriculo.pdf $out/curriculo.pdf
              cp curriculo.pdf $out/resumes/pt-br/curriculo.pdf
            '';
          };
        in
        {
          packages = {
            default = cv-all;
            en = cv-en;
            pt = cv-pt;
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
