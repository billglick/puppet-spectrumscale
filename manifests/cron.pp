# Parameters: 
#     accept_license - Boolean - install cron script to auto accept license
class gpfs::cron (
    Boolean $accept_license,
) {

    # RESOURCE DEFAULTS
    File {
        owner    => 'root',
        group    => 'root',
        mode     => '0700',
    }
    Cron {
        user    => 'root',
        ensure  => present,
    }

    # CRON FILE LOCATIONS
    $root_cron       = '/root/cron'
    $fn_gpfs_oom     = "${root_cron}/gpfs_oom.sh"
    $fn_gpfs_license = "${root_cron}/gpfs_license.sh"
#    $fn_crontab      = '/etc/cron.d/gpfs'

    # CRON DIRECTORY
    file { $root_cron :
        ensure   => 'directory',
    }

    # EXEMPT GPFS FROM OOM KILLER
    file { $fn_gpfs_oom :
        ensure  => present,
        source  => "puppet:///modules/gpfs${fn_gpfs_oom}"
    }
    cron { 'gpfs_oom' :
        command => $fn_gpfs_oom,
        hour    => 0,
        minute  => 2,
    }

    # CHECK & ACCEPT LICENSE FEATURE IS OPTIONAL
    if $accept_license {
        $license_ensure = 'present'
    }
    else {
        $license_ensure = 'absent'
    }
    file { $fn_gpfs_license :
        ensure   => $license_ensure,
        source   => "puppet:///modules/gpfs${fn_gpfs_license}",
    }
    cron { 'gpfs_license' :
        command  => $fn_gpfs_license,
        ensure   => $license_ensure,
        hour     => 0,
        minute   => 1,
    }
}