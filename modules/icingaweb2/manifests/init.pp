class icingaweb2 (
  $config_dir 		= $::icingaweb2::config_dir,
  $web_config_dir_mode 	= $::icingaweb2::config_dir_mode,
  $web_config_file_mode = $::icingaweb2::config_file_mode,
  $config_user 		= $::icingaweb2::config_user,
  $config_group		= $::icingaweb2::config_group,
  $web_module_dir 	= $::icingaweb2::web_module_dir,
) inherits icingaweb2::params {

  validate_string($config_dir)
  validate_string($web_module_dir)

  package { 'icingaweb2':
    ensure 	=> latest,
    require 	=> [ Package['php-ZendFramework'], Package['php-ZendFramework-Db-Adapter-Pdo-Mysql'] ],
    alias 	=> 'icingaweb2'
  }

  package { 'php-Icinga':
    ensure 	=> latest,
    require 	=> [ Package['php-ZendFramework'], Package['php-ZendFramework-Db-Adapter-Pdo-Mysql'] ],
    alias 	=> 'php-Icinga'
  }

  package { 'icingacli':
    ensure 	=> latest,
    require 	=> [ Package['php-ZendFramework'], Package['php-ZendFramework-Db-Adapter-Pdo-Mysql'] ],
    alias 	=> 'icingacli'
  }

  package { ['php-ZendFramework', 'php-ZendFramework-Db-Adapter-Pdo-Mysql']:
    ensure 	=> latest,
  }

  file {
    $::icingaweb2::config_dir:
      ensure 	=> directory,
      mode 	=> $::icingaweb2::config_dir_mode,
      owner	=> $::icingaweb2::config_user,
      group	=> $::icingaweb2::config_group,
      require 	=> Package['icingaweb2'];

    "$::icingaweb2::config_dir/authentication.ini":
      mode 	=> $::icingaweb2::config_file_mode,
      owner	=> $::icingaweb2::config_user,
      group	=> $::icingaweb2::config_group,
      content 	=> template("icingaweb2/authentication.ini.erb");

    "$::icingaweb2::config_dir/config.ini":
      mode 	=> $::icingaweb2::config_file_mode,
      owner	=> $::icingaweb2::config_user,
      group	=> $::icingaweb2::config_group,
      content 	=> template("icingaweb2/config.ini.erb");

    "$::icingaweb2::config_dir/roles.ini":
      mode 	=> $::icingaweb2::config_file_mode,
      owner	=> $::icingaweb2::config_user,
      group	=> $::icingaweb2::config_group,
      content 	=> template("icingaweb2/roles.ini.erb");

    "$::icingaweb2::config_dir/resources.ini":
      mode 	=> $::icingaweb2::config_file_mode,
      owner	=> $::icingaweb2::config_user,
      group	=> $::icingaweb2::config_group,
      content 	=> template("icingaweb2/resources.ini.erb");

    "$::icingaweb2::config_dir/modules":
      ensure 	=> directory,
      mode 	=> $::icingaweb2::config_dir_mode,
      owner	=> $::icingaweb2::config_user,
      group	=> $::icingaweb2::config_group;

    "$::icingaweb2::config_dir/enabledModules":
      ensure 	=> directory,
      mode 	=> $::icingaweb2::config_dir_mode,
      owner	=> $::icingaweb2::config_user,
      group	=> $::icingaweb2::config_group;
  }

  file {
    "$::icingaweb2::config_dir/modules/monitoring":
      ensure 	=> directory,
      mode 	=> $::icingaweb2::config_dir_mode,
      owner	=> $::icingaweb2::config_user,
      group	=> $::icingaweb2::config_group,
      require 	=> File["$::icingaweb2::config_dir/modules"];
  }

  file {
    "$::icingaweb2::config_dir/modules/monitoring/backends.ini":
      mode 	=> $::icingaweb2::config_file_mode,
      owner	=> $::icingaweb2::config_user,
      group	=> $::icingaweb2::config_group,
      content 	=> template("icingaweb2/modules/monitoring/backends.ini.erb"),
      require 	=> File["$::icingaweb2::config_dir/modules/monitoring"];

    "$::icingaweb2::config_dir/modules/monitoring/config.ini":
      mode 	=> $::icingaweb2::config_file_mode,
      owner	=> $::icingaweb2::config_user,
      group	=> $::icingaweb2::config_group,
      content 	=> template("icingaweb2/modules/monitoring/config.ini.erb"),
      require 	=> File["$::icingaweb2::config_dir/modules/monitoring"];

    "$::icingaweb2::config_dir/modules/monitoring/commandtransports.ini":
      mode 	=> $::icingaweb2::config_file_mode,
      owner	=> $::icingaweb2::config_user,
      group	=> $::icingaweb2::config_group,
      content 	=> template("icingaweb2/modules/monitoring/commandtransports.ini.erb"),
      require 	=> File["$::icingaweb2::config_dir/modules/monitoring"];
  }

  file {
    "$::icingaweb2::web_module_dir":
      ensure 	=> directory,
      require	=> Package['icingaweb2'];
  }

  icingaweb2::module { [ 'doc', 'monitoring' ]:
    builtin 	=> true,
  }
}

