/*
 * Copyright 2020-2025 Hewlett Packard Enterprise Development LP
 * Copyright 2004-2019 Cray Inc.
 * Other additional copyright holders may be indicated within.
 *
 * The entirety of this work is licensed under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 *
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _APRUN_UTILS_H_
#define _APRUN_UTILS_H_

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
  aprun_cc,   // binding policy
  aprun_n,    // num locales
  aprun_d,    // cores per locale
  aprun_N,    // locales per node
  aprun_j,    // cpus per node (newer versions of aprun)
  aprun_L,    // node list
  aprun_none
} aprun_arg_t;

void initAprunAttributes(void);
const char* getCoresPerLocaleStr(void);
int getCoresPerLocale(void);
const char* getLocalesPerNodeStr(void);
int getLocalesPerNode(void);
const char* getCPUsPerCUStr(void);
int getCPUsPerCU(void);
const char *getNodeListStr(void);
char *getNodeListOpt(void);
const char* getNumLocalesStr(void);
const char* getAprunArgStr(aprun_arg_t arg); // possibly inline
int getAprunArg(aprun_arg_t argt);           // possibly inline

char** chpl_create_aprun_cmd(int argc, char* argv[],
                             int32_t numLocales, const char* _ccArg);

#ifdef __cplusplus
}
#endif

#endif
