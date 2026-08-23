{
  pkgs,
  username,
  hostname,
  ...
}:
{
  imports = [
    ../../modules/darwin
  ];

  # Host identity
  networking.hostName = hostname;
  networking.computerName = "MacBook Neo";
  networking.localHostName = hostname;

  # Primary user (required by modern nix-darwin)
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # Used for backwards compatibility. Read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
