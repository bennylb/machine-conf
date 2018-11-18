self: super: {

clipster = super.clipster.overrideAttrs (oldAttrs: { src = /home/ben/src/git/clipster; });

}
