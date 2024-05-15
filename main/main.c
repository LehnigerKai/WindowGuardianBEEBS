/* Common main.c for the benchmarks

   Copyright (C) 2014 Embecosm Limited and University of Bristol
   Copyright (C) 2018 Embecosm Limited

   Contributor: James Pallister <james.pallister@bristol.ac.uk>
   Contributor: Jeremy Bennett <jeremy.bennett@embecosm.com>

   This file is part of the Bristol/Embecosm Embedded Benchmark Suite.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

   SPDX-License-Identifier: GPL-3.0-or-later */

#include "support.h"
#include "esp_timer.h"

extern int initialise_benchmark (void);

unsigned int __window_counter = 0;	// global counter for window overflows

void app_main (){
  int i;

  initialise_benchmark ();
  int64_t start = esp_timer_get_time();
  __window_counter = 0;
  for (i = 0; i < REPEAT_FACTOR; i++)
    {
      initialise_benchmark ();
      benchmark ();
    }
  int64_t stop = esp_timer_get_time();
#if defined(SEC_METHOD) && SEC_METHOD == -1
  printf("Result: %u\n", __window_counter);
#else
  printf("Result: %lld\n", stop-start);
#endif
}
