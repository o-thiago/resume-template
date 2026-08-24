{
  description = "Thiago Macedo Mendes - Curriculum Vitae (LaTeX / ModernCV / Nix)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      perSystem =
        { pkgs, ... }:
        let
          tex = pkgs.texliveFull;

          buildCv =
            { name, srcDir }:
            pkgs.stdenv.mkDerivation {
              pname = "cv-${name}";
              version = "1.0.0";
              src = ./.;

              nativeBuildInputs = [ tex ];

              buildPhase = ''
                cd resumes/${srcDir}
                pdflatex -interaction=nonstopmode ${name}.tex
                pdflatex -interaction=nonstopmode ${name}.tex
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

            nativeBuildInputs = [ tex ];

            buildPhase = ''
              mkdir -p build/en build/pt-br
              cp -r resumes/en/* build/en/
              (cd build/en && pdflatex -interaction=nonstopmode resume.tex)
              cp -r resumes/pt-br/* build/pt-br/
              (cd build/pt-br && pdflatex -interaction=nonstopmode curriculo.tex)
            '';

            installPhase = ''
              mkdir -p $out/resumes/en $out/resumes/pt-br
              cp -r resumes $out/
              cp build/en/resume.pdf $out/resume.pdf
              cp build/pt-br/curriculo.pdf $out/curriculo.pdf
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
            buildInputs = [ tex ];
          };
        };
    };
}
