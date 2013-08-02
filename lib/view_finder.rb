class ViewFinder
  include CoPilot
  def view_location_x(view_name)

    view_info = JSON.parse(platform.get_view_by_id(view_name).body)
    return view_info["screenLocation"][0]
  end

  def view_location_y(view_name)
    view_info = JSON.parse(platform.get_view_by_id(view_name).body)
    return view_info["screenLocation"][1]
  end

  def get_textview_from_list

    view_info = JSON.parse(platform.get_view_by_id('mnavigator_list_view2').body)
    puts view_info
    viewId = view_info["id"]
    puts viewId

    platform.chain_calls do |device|
      device.get_view viewId, :variable => '@@list_view@@', :target => 'Robotium'
      list_view = '@@list_view@@'
      list_view.getCurrentTextViewsInList

    end

    #text_array = list.getTextViewsInList :target => 'Robotium'
    #text_array.each {|text_v| print JSON.parse(text_v.body)}
  end
end