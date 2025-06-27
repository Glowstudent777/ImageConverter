#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION

#include <iostream>
#include <string>
#include <filesystem>
#include <vector>
#include <cstring>
#include <fstream>

#include "stb_image.h"
#include "stb_image_write.h"
#include "converter_utils.h"
#include "webp/encode.h"
#include "webp/decode.h"

bool convertImage(const std::string &inputPath, const std::string &outputFormatRaw)
{
    std::filesystem::path inPath(inputPath);
    std::string fromExt = toLower(inPath.extension().string());
    std::string outputFormat = toLower(outputFormatRaw);

    if (!fromExt.empty() && fromExt[0] == '.')
        fromExt.erase(0, 1);

    int width = 0, height = 0, channels = 0;
    unsigned char *data = nullptr;

    if (!std::filesystem::exists(inPath))
    {
        std::cerr << "File does not exist: " << inputPath << "\n";
        return false;
    }

    if (fromExt == "webp")
    {
        std::ifstream file(inPath, std::ios::binary);
        if (!file)
        {
            std::cerr << "Failed to open file: " << inputPath << "\n";
            return false;
        }

        std::vector<uint8_t> buffer((std::istreambuf_iterator<char>(file)), {});
        data = WebPDecodeRGB(buffer.data(), buffer.size(), &width, &height);
        channels = 3;
    }
    else
    {
        data = stbi_load(inputPath.c_str(), &width, &height, &channels, 0);
    }

    if (!data)
    {
        std::cerr << "Failed to load image: " << inputPath << "\n";
        return false;
    }

    if (outputFormat == fromExt)
    {
        std::cerr << "Input and output formats are the same: " << outputFormat << "\n";
        stbi_image_free(data);
        return false;
    }

    std::string outPath = inPath.stem().string() + "_converted." + outputFormat;
    bool success = false;

    if (outputFormat == "png")
    {
        success = stbi_write_png(outPath.c_str(), width, height, channels, data, width * channels);
    }
    else if (outputFormat == "jpg" || outputFormat == "jpeg")
    {
        success = stbi_write_jpg(outPath.c_str(), width, height, channels, data, 95);
    }
    else if (outputFormat == "webp")
    {
        uint8_t *webpData = nullptr;
        size_t webpSize = WebPEncodeRGB(data, width, height, width * channels, 95, &webpData);
        if (webpSize == 0 || webpData == nullptr)
        {
            std::cerr << "Failed to encode WebP image.\n";
            stbi_image_free(data);
            return false;
        }

        FILE *outFile = fopen(outPath.c_str(), "wb");
        if (outFile)
        {
            fwrite(webpData, 1, webpSize, outFile);
            fclose(outFile);
            success = true;
        }
        else
        {
            std::cerr << "Failed to write WebP file: " << outPath << "\n";
        }
        WebPFree(webpData);
    }
    else
    {
        std::cerr << "Unsupported format: " << outputFormat << "\n";
    }

    stbi_image_free(data);
    return success;
}

int main(int argc, char *argv[])
{
    if (argc < 3)
    {
        std::cerr << "Usage: converter.exe --to=png|jpg|webp <file>\n";
        return 1;
    }

    std::string format;
    std::string inputPath;

    for (int i = 1; i < argc; ++i)
    {
        if (strncmp(argv[i], "--to=", 5) == 0)
        {
            format = std::string(argv[i] + 5);
        }
        else
        {
            inputPath = argv[i];
        }
    }

    if (format.empty() || inputPath.empty())
    {
        std::cerr << "Invalid arguments.\n";
        return 1;
    }

    if (convertImage(inputPath, format))
    {
        std::cout << "Conversion successful.\n";
    }
    else
    {
        std::cerr << "Conversion failed.\n";
        return 1;
    }

    return 0;
}
