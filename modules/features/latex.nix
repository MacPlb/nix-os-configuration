# LaTeX for documents and Beamer presentations: TeX Live medium plus the extra packages below
# (a fraction of texliveFull's size), latexmk to build, texlab for editor completion and zathura
# to preview with SyncTeX. TeXstudio is the GUI editor: built-in PDF preview with SyncTeX
# (click in the PDF to jump to the source), a Beamer frame outline and a Quick Beamer wizard.
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
