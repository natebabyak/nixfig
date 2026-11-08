{ username, ... }:

{
  imports = [ ./configuration.nix ];

  users.users.${username} = {
    isNormalUser = true;
    description = "Nate Babyak";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
}
