using DrWatson
@quickactivate "PLP-Pipeline"

import Downloads:
    download

urls = read(datadir("exp_raw", "urls.txt"), String) |> split

for url in urls
    path = datadir("exp_raw", basename(url))
    if !isfile(path)
        Downloads.download(url, path)
    else
        println("$filename already exists")
    end
end

println("All raw data files downloaded successfully!")
