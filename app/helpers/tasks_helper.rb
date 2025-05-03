module TasksHelper
  def task_status_classes(status)
    case status
    when "completed"
      "bg-green-50 text-green-700 border border-green-100"
    when "in_progress"
      "bg-amber-50 text-amber-700 border border-amber-100"
    else
      "bg-gray-50 text-gray-700 border border-gray-100"
    end
  end

  def task_status_color(task)
    case task.status
    when "completed"
      "bg-green-500"
    when "in_progress"
      "bg-amber-500"
    else
      "bg-gray-500"
    end
  end
end
