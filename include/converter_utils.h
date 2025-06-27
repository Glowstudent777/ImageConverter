#ifndef CONVERTER_UTILS_H
#define CONVERTER_UTILS_H

#include <string>

std::string toLower(std::string str)
{
    for (int i = 0; i < str.length(); i++)
    {
        str[i] = tolower(str[i]);
    }

    return str;
}

void normalizeString(std::string &str)
{
    std::string temp;
    bool first = true;

    for (int i = 0; i < str.length(); i++)
    {
        if ((str[i + 1] == ' ' && str[i] == ' ') || (first && str[i] == ' ') || (!str[i + 1] && str[i] == ' '))
            continue;

        temp += str[i];
        first = false;
    }

    str = temp;
}

#endif