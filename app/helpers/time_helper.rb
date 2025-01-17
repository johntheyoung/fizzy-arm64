module TimeHelper
  def local_datetime_tag(datetime, style: :time, delimiter: nil, **attributes)
    tag.time **attributes, datetime: datetime.iso8601, data: { local_time_target: style, delimiter: delimiter }
  end
end
