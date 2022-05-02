defmodule Challenge01Reports do
  alias Challenge01Reports.Parser

  @months %{
    1 => "janeiro",
    2 => "fevereiro",
    3 => "março",
    4 => "abril",
    5 => "maio",
    6 => "junho",
    7 => "julho",
    8 => "agosto",
    9 => "setembro",
    10 => "outubro",
    11 => "novembro",
    12 => "dezembro"
  }

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report ->
      sum_values(line, report)
    end)
  end

  def build(), do: { :error, "Invalid Option" }

  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_acc(), fn { :ok, result }, report -> sum_reports(report, result) end)
  end

  defp report_acc do
    allHours = %{}
    hoursPerMonth = %{}
    hoursPerYear = %{}

    build_report(allHours, hoursPerMonth, hoursPerYear)
  end

  defp sum_reports( %{ "all_hours" => allHours1,  "hours_per_month" => hoursPerMonth1, "hoursPerYear" => hoursPerYear1 },  %{ "all_hours" => allHours2,  "hours_per_month" => hoursPerMonth2, "hoursPerYear" => hoursPerYear2 }) do
    allHours = merge_maps(allHours1, allHours2)
    hoursPerMonth = merge_maps_list(hoursPerMonth1, hoursPerMonth2)
    hoursPerYear = merge_maps_list(hoursPerYear1, hoursPerYear2)

    build_report(allHours, hoursPerMonth, hoursPerYear)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  defp merge_maps_list(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> merge_maps(value1, value2) end)
  end

  defp sum_values([ name, qtde, day, month, year ], %{ "all_hours" => allHours,  "hours_per_month" => hoursPerMonth, "hoursPerYear" => hoursPerYear }) do
    allHours = Map.put(allHours, name, recover_value(allHours[name]) + qtde)
    hoursPerMonth = Map.put(hoursPerMonth, name, recover_value(hoursPerMonth[name], @months[month], qtde))
    hoursPerYear = Map.put(hoursPerYear, name, recover_value(hoursPerYear[name], year, qtde))

    build_report(allHours, hoursPerMonth, hoursPerYear)
  end

  defp recover_value(value), do: if is_nil(value), do: 0, else: value

  defp recover_value(object, key, value) do
     if is_nil(object), do: %{ key => value }, else: Map.put(object, key, recover_value(object[key]) + value)
  end

  defp build_report(allHours, hoursPerMonth, hoursPerYear), do: %{ "all_hours" => allHours, "hours_per_month" => hoursPerMonth, "hoursPerYear" => hoursPerYear }
end
