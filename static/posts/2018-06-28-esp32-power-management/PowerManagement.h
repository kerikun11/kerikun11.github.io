/**
 * @file PowerManagement.h
 * @author kerikun11
 * @date 2018.06.28
 */
#pragma once

#include "esp_err.h"
#include "esp_pm.h"
#include "sdkconfig.h"
#include <stdio.h>

class PowerManagement {
public:
  static void init() {
    // Configure dynamic frequency scaling: maximum frequency is set in
    // sdkconfig, minimum frequency is XTAL.
    rtc_cpu_freq_t max_freq;
    rtc_clk_cpu_freq_from_mhz(CONFIG_ESP32_DEFAULT_CPU_FREQ_MHZ, &max_freq);
    esp_pm_config_esp32_t pm_config = {
      .max_cpu_freq = max_freq,
      .min_cpu_freq = RTC_CPU_FREQ_XTAL,
#if CONFIG_FREERTOS_USE_TICKLESS_IDLE
      .light_sleep_enable = true
#endif
    };
    ESP_ERROR_CHECK(esp_pm_configure(&pm_config));
  }
  static void printLockStatus() { ESP_ERROR_CHECK(esp_pm_dump_locks(stdout)); }

public:
  class Lock {
  public:
    Lock(esp_pm_lock_type_t lock_type, const char *name) {
      ESP_ERROR_CHECK(esp_pm_lock_create(lock_type, 0, name, &lock_handle));
    }
    void acquire() { ESP_ERROR_CHECK(esp_pm_lock_acquire(lock_handle)); }
    void release() { ESP_ERROR_CHECK(esp_pm_lock_release(lock_handle)); }

  private:
    esp_pm_lock_handle_t lock_handle;
  };
};
