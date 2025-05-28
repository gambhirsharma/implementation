#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>
#include "weather.h"

#define API_URL "http://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s"

struct Memory {
  char *response;
  size_t size;
};


static size_t write_callback(void *contents, size_t size, size_t nmemb, void *userp){
    size_t total_size = size * nmemb;
    struct Memory *mem = (struct Memory *)userp;

    char *ptr = realloc(mem->response, mem->size + total_size + 1);
    if (!ptr) return 0;

    mem->response = ptr;
    memcpy(&(mem->response[mem->size]), contents, total_size);
    mem->size += total_size;
    mem->response[mem->size] = 0;

    return total_size;
}

void fetch_weather(const char *city, const char *api_key) {
  CURL *curl;
  CURLcode res;
  struct Memory chunk = {NULL, 0};

  char url[256];
  snprintf(url, sizeof(url), API_URL, city, api_key);

    curl = curl_easy_init();

    if (curl){
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, (void *)&chunk);
        res = curl_easy_perform(curl);

        if(res == CURLE_OK){
            printf("%s\n", chunk.response);
        }
        else {
            fprintf(stderr, "Failed to fetch data: %s\n", curl_easy_strerror(res));
        }


        free(chunk.response);
        curl_easy_cleanup(curl);
    }
    else {
        fprintf(stderr, "Failed to initalized curl \n");
    }
}
