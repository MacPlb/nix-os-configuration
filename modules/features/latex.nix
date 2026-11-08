# LaTeX and Beamer: TeX Live medium plus the packages below, latexmk, texlab and zathura.
# TeXstudio is the GUI editor and supports SyncTeX.
{
  flake.nixosModules.latex =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        (texliveMedium.withPackages (
          ps: with ps; [
            # Most of CTAN's general-purpose packages (tcolorbox, enumitem, todonotes, …).
            collection-latexextra
            collection-fontsrecommended
            collection-mathscience
            collection-langpolish

            # Presentations
            beamer
            beamertheme-metropolis

            # Bibliographies, e.g. exported from Zotero
            biblatex
            biber

            # Plots and syntax-highlighted code (minted needs -shell-escape)
            pgfplots
            minted

            latexmk
            chktex
            latexindent
          ]
        ))
        # minted highlights through Pygments.
        python3Packages.pygments

        texlab
        zathura
        texstudio
      ];
    };
}
