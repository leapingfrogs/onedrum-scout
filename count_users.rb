class CountOneDrumUsers < Scout::Plugin
  OPTIONS=<<-EOS
    prefs_file:
      name: Target Preferences File
      default: server/configuration/.settings/org.eclipse.core.runtime.preferences.OSGiPreferences.3.prefs
  EOS

  def build_report
    report :total_accounts => total_accounts,
           :active_accounts => active_accounts
  end

  def total_accounts
    if `grep com.quolos.basicid.username=true #{prefs_file_path} | wc -l` =~ /(\d+)/
      $1.to_i
    else
      error "Attempt to retrieve total accounts failed"
    end
  end

  def active_accounts
    if `grep com.quolos.basicid.lastLogin=true #{prefs_file_path} | wc -l` =~ /(\d+)/
      $1.to_i
    else
      error "Attempt to retrieve active accounts failed"
    end
  end

  def prefs_file_path
    error "The path to the prefs file must be set" if option('prefs_file').nil?

    option('prefs_file')
  end
end