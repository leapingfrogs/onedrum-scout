class CountOneDrumUsers < Scout::Plugin
  OPTIONS=<<-EOS
    prefs_file:
      name: Target Preferences File
      default: server/configuration/.settings/org.eclipse.core.runtime.preferences.OSGiPreferences.3.prefs
  EOS
    
  def build_report
    report :total_accounts => total_accounts, :active_accounts => active_accounts
  end

  def total_accounts
    if `grep com.quolos.basicid.username=true #{prefs_file} | wc -l` =~ /(\d+)/
      $1.to_i
    else
      error "Attempt to retrieve total accounts failed"       
    end
  end
     
  def active_accounts
    0
  end

  def prefs_file_path
    prefs_file = option('prefs_file')
    
    error "The path to the prefs file must be set" if prefs_file.nil?
    
    return prefs_file.to_s
  end
end