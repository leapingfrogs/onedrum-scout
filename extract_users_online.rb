class ExtractUsersOnline < Scout::Plugin
  OPTIONS=<<-EOS
    data_metrics_log_file:
      name: Target Log File
      default: onedrum_data_metrics.log
  EOS

  def build_report
    users_online = nil

    if(!File.exists?(data_metrics_log_path)) then
      return
    end

    lines = File.readlines(data_metrics_log_path)

    until (lines.empty?)
      line = lines.pop

      if (line =~ /\]/) then
        line = line[line.index(']') + 1, line.length]
        line.strip!

        if (line =~ /^[{].*report_type[ ]=[ ][']users_online['].*[}]$/) then
          users_online = $1.to_i if users_online.nil? && line =~ /count[ ]=[ ](\d*)/
        end
      end

      break if users_online
    end

    users_online ||= 0

    report :users_online => users_online
  end

  def data_metrics_log_path
    error "The path to the prefs file must be set" if option('data_metrics_log_file').nil?

    option('data_metrics_log_file')
  end
end