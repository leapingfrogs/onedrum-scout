class ExtractBulkStats < Scout::Plugin
  OPTIONS=<<-EOS
    data_metrics_log_file:
      name: Target Log File
      default: onedrum_data_metrics.log
  EOS

  def build_report
    total_users = nil
    workspaces = nil
    chat_messages = nil
    total_files = nil
    collaborative_files = nil

    if(!File.exists?(data_metrics_log_path)) then
      return
    end

    lines = File.readlines(data_metrics_log_path)

    until (lines.empty?)
      line = lines.pop

      if (line =~ /\]/) then
        line = line[line.index(']') + 1, line.length]
        line.strip!

        if (line =~ /^[{].*report_type[ ]=[ ]bulk_stats.*[}]$/) then
          total_users = $1.to_i if total_users.nil? && line =~ /total_users[ ]=[ ](\d*)/
          workspaces = $1.to_i if workspaces.nil? && line =~ /workspaces[ ]=[ ](\d*)/
          chat_messages = $1.to_i if  chat_messages.nil? && line =~ /chat_messages[ ]=[ ](\d*)/
          total_files = $1.to_i if total_files.nil? && line =~ /total_files[ ]=[ ](\d*)/
          collaborative_files = $1.to_i if collaborative_files.nil? && line =~ /collaborative_files[ ]=[ ](\d*)/
        end
      end

      break if total_users && workspaces && chat_messages && total_files && collaborative_files
    end

    total_users ||= 0
    workspaces ||= 0
    chat_messages ||= 0
    total_files ||= 0
    collaborative_files ||= 0

    report :total_users => total_users,
           :workspaces => workspaces,
           :chat_messages => chat_messages,
           :total_files => total_files,
           :collaborative_files => collaborative_files
  end

  def data_metrics_log_path
    error "The path to the prefs file must be set" if option('data_metrics_log_file').nil?

    option('data_metrics_log_file')
  end
end