<div align="center">

![License](https://img.shields.io/github/license/celiobjunior/resume-template?style=flat-square&color=blue)
![Typst](https://img.shields.io/badge/Made%20with-Typst-239dad?logo=typst&style=flat-square)
![Nix](https://img.shields.io/badge/Reproducible-Nix-5277C3?logo=nixos&style=flat-square)
![Maintained](https://img.shields.io/badge/Maintained-Yes-green?style=flat-square)

</div>

<div align="center">
  <h3>
    <a href="#english">🇺🇸 English</a> | <a href="#português">🇧🇷 Português</a>
  </h3>
</div>

---

<div id="english"></div>

# Typst Resume Template

A professional, clean, and modern resume template ported to [Typst](https://typst.app). Driven by structured CV data (`cv-data`), compiling to high-quality PDFs in milliseconds.

## Features
- **Data-Driven**: Resumes consume data directly from central `cv-data` (`cv.yaml` / `cv.toml`).
- **Lightning Fast**: Compiles instantaneously via Typst CLI.
- **Reproducible**: Managed and built with Nix flakes (`nix build`).
- **Bilingual**: Full support for English (`resumes/en/resume.typ`) and Brazilian Portuguese (`resumes/pt-br/curriculo.typ`).

## Building

### Using Nix
```bash
nix build
# Output PDFs will be in ./result/
```

### Using Typst CLI
```bash
# English
typst compile --root . resumes/en/resume.typ resumes/en/resume.pdf

# Portuguese
typst compile --root . resumes/pt-br/curriculo.typ resumes/pt-br/curriculo.pdf
```

---

<div id="português"></div>

# Modelo de Currículo em Typst

Um modelo de currículo profissional, limpo e moderno portado para o [Typst](https://typst.app). Alimentado por dados estruturados centralizados (`cv-data`), compilando PDFs de alta fidelidade em milissegundos.

## Recursos
- **Orientado a Dados**: O currículo consome informações diretamente do repositório central `cv-data` (`cv.yaml` / `cv.toml`).
- **Ultrarrápido**: Compilação instantânea com a CLI do Typst.
- **Reprodutível**: Empacotado e compilado com Nix flakes (`nix build`).
- **Bilíngue**: Suporte completo para Inglês (`resumes/en/resume.typ`) e Português Brasileiro (`resumes/pt-br/curriculo.typ`).

## Como Compilar

### Usando Nix
```bash
nix build
# Os PDFs gerados estarão em ./result/
```

### Usando a CLI do Typst
```bash
# Inglês
typst compile --root . resumes/en/resume.typ resumes/en/resume.pdf

# Português
typst compile --root . resumes/pt-br/curriculo.typ resumes/pt-br/curriculo.pdf
```

---

## License / Licença

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE.md) file for details.