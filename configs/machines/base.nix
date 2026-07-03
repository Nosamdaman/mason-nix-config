# Base NixOS machine configuration
#
# This file defines a NixOS module representing the most basic configuration for my NixOS systems. It makes no
# assumptions about hardware and doesn't come with a desktop environment pre-configured.
{ config, pkgs, inputs, ... }: let
    cuda-packages = inputs.nix-cuda-toolkit.packages.${pkgs.stdenv.hostPlatform.system};
in {
    # Configure nix itself. We'll allow for the installation of non-free software and enable support for flakes and the
    # new nix command line. We'll also increase the download buffer size.
    nixpkgs.config.allowUnfree = true;
    nix.settings = {
        download-buffer-size = 536870912;
        experimental-features = [ "nix-command" "flakes" ];
    };

    # Use the latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Use NetworkManger to manage networking
    networking.networkmanager = {
        enable = true;
        dns = "dnsmasq";
    };

    # Enable the firewall
    networking.firewall.enable = true;

    # Set the timezone to US/Eastern and enable NTP for clock syncing
    time.timeZone = "US/Eastern";
    services.timesyncd.enable = true;

    # Set our locale to US English in UTF-8 and configure the Linux console
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        enable = true;
        earlySetup = true;
        keyMap = "us";
    };

    # Enable the power-profiles-daemon service for better CPU scaling behavior
    services.power-profiles-daemon.enable = true;

    # Here's where we'll some of the software installed on the machine. These packages have more complex configurations
    # than the standard system packages, so they're handled differently.
    programs = {
        # Bash and Fish are the two main shells used with this config
        bash.enable = true;
        fish.enable = true;

        # Git is obviously extremely important for software development. In addition to git, we'll also enable support
        # for git-lfs. I don't actually like git-lfs, but it's necessary for some repositories.
        git = {
            enable = true;
            lfs.enable = true;
        };

        # Less is my preferred pager program
        less.enable = true;

        # htop is an excellent process monitoring tool
        htop.enable = true;

        # The GNUPG agent will allow for cryprography shit or something, idk
        gnupg.agent.enable = true;
    };

    # Here's where we'll configure the rest of the system packages. These just get installed as is.
    environment.systemPackages = with pkgs; [
        # Install coreutils and a few other packages I consider essential for a usable Linux system
        acl
        attr
        btop-cuda
        bzip2
        coreutils-full
        cpio
        curl
        diffutils
        findutils
        gawkInteractive
        getconf
        getent
        gnugrep
        gnupatch
        gnused
        gnutar
        gzip
        libcap
        mkpasswd
        ncurses
        netcat
        nvtopPackages.full
        openssh
        openssl_4_0
        procps
        python3
        su
        sudo
        time
        unzip
        util-linux
        wget
        which
        xz
        zstd

        # Vim and Kakoune are our primary text editors, we'll also install some Kakoune plugins that I like
        vim
        kakoune
        kakoune-lsp
        kak-tree-sitter

        # Install the primary suite of development tools
        autoconf
        automake
        binutils
        bison
        clang
        cmakeWithGui
        cuda-packages.cuda-devenv_13_3
        cuda-packages.cuda-devenv_13_0
        cuda-packages.cuda-devenv_12_8
        debugedit
        fakeroot
        file
        flex
        gcc
        gettext
        git-credential-manager
        gnum4
        gnumake
        gnupg
        libpkgconf
        libtool
        libtree
        meson
        ninja
        pass-wayland
        perf
        texinfo
        tig
    ];

    # Configure how documentation is generated for the system. In particular, we'll use man-db as our pager and enable
    # just about as much documentation as is possible.
    documentation = {
        enable = true;
        dev.enable = true;
        doc.enable = true;
        info.enable = true;
        man = {
            enable = true;
            cache = {
                enable = true;
                generateAtRuntime = false;
            };
            man-db.enable = true;
        };
        nixos.enable = true;
    };

    # Configure our default system fonts. This is realistically unnecessary since we don't have a GUI, but I like these
    # fonts so I think it's worth the extra storage to not have to specify these each time.
    fonts = {
        packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-color-emoji
            liberation_ttf
            nerd-fonts.fira-code
        ];
        fontconfig = {
            enable = true;
            defaultFonts = {
                serif = [ "Noto Serif" ];
                sansSerif = [ "Noto Sans" ];
                monospace = [ "FiraCode Nerd Font" ];
                emoji = [ "Noto Color Emoji" ];
            };
        };
    };

    # Create our default users, this is just me for now
    users.users.mason = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
    };
}
