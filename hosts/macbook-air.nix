{ self, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "will.ext";
  system.stateVersion = 6;
  system.configurationRevision = self.rev or self.dirtyRev or null;
}
