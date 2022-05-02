defmodule Challenge01Reports.Parser do
  def parse_file(filename) do
    "reports/#{filename}"
    |> File.stream!()
    |> Stream.map(fn line -> parse_line(line) end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(1, fn elem -> String.to_integer(elem) end)
    |> List.update_at(2, fn elem -> String.to_integer(elem) end)
    |> List.update_at(3, fn elem -> String.to_integer(elem) end)
    |> List.update_at(4, fn elem -> String.to_integer(elem) end)
  end
end
