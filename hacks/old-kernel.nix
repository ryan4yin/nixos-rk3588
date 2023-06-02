{pkgs, ...}: let
  patchUtilLinux = ul:
    ul.overrideAttrs (old: {
      patches =
        old.patches
        ++ [
          (pkgs.fetchpatch {
            url = "https://github.com/util-linux/util-linux/commit/f94a7760ed7ce81389a6059f020238981627a70d.diff";
            hash = "sha256-UorqDeECK8pBePkmpo2x90p/jP3rCMshyPCyijSX1wo=";
          })
          (pkgs.fetchpatch {
            url = "https://github.com/util-linux/util-linux/commit/1bd85b64632280d6bf0e86b4ff29da8b19321c5f.diff";
            hash = "sha256-dgu4de5ul/si7Vzwe8lr9NvsdI1CWfDQKuqvARaY6sE=";
          })
        ];
    });
  util-linuxMinimal' = patchUtilLinux pkgs.util-linuxMinimal;
in {
  boot.initrd.systemd.package = pkgs.systemdStage1.override {util-linux = util-linuxMinimal';};
  systemd.package = pkgs.systemd.override {util-linux = util-linuxMinimal';};
  system.replaceRuntimeDependencies = [
    {
      original = pkgs.util-linux;
      replacement = patchUtilLinux pkgs.util-linux;
    }
  ];
}
