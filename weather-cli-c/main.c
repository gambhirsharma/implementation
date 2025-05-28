#include <stdio.h>
#include "weather.h"

int main(){
    const char *city = "Rome";
    const char *api_key = "80bfc1822220761dbe83445a450fb563";

    printf("Weather in %s\n", city);
    fetch_weather(city, api_key);

    return 0;

}
