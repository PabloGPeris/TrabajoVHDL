/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_129(char*, char *);
extern void execute_130(char*, char *);
extern void execute_131(char*, char *);
extern void execute_132(char*, char *);
extern void execute_133(char*, char *);
extern void execute_134(char*, char *);
extern void execute_135(char*, char *);
extern void execute_11(char*, char *);
extern void execute_12(char*, char *);
extern void execute_126(char*, char *);
extern void execute_127(char*, char *);
extern void execute_128(char*, char *);
extern void execute_52(char*, char *);
extern void execute_15(char*, char *);
extern void execute_16(char*, char *);
extern void execute_17(char*, char *);
extern void execute_18(char*, char *);
extern void execute_30(char*, char *);
extern void execute_31(char*, char *);
extern void execute_32(char*, char *);
extern void execute_33(char*, char *);
extern void execute_94(char*, char *);
extern void execute_99(char*, char *);
extern void execute_100(char*, char *);
extern void execute_110(char*, char *);
extern void execute_111(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[29] = {(funcp)execute_129, (funcp)execute_130, (funcp)execute_131, (funcp)execute_132, (funcp)execute_133, (funcp)execute_134, (funcp)execute_135, (funcp)execute_11, (funcp)execute_12, (funcp)execute_126, (funcp)execute_127, (funcp)execute_128, (funcp)execute_52, (funcp)execute_15, (funcp)execute_16, (funcp)execute_17, (funcp)execute_18, (funcp)execute_30, (funcp)execute_31, (funcp)execute_32, (funcp)execute_33, (funcp)execute_94, (funcp)execute_99, (funcp)execute_100, (funcp)execute_110, (funcp)execute_111, (funcp)transaction_0, (funcp)transaction_1, (funcp)vhdl_transfunc_eventcallback};
const int NumRelocateId= 29;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/FSM_Main_tb_v2_behav/xsim.reloc",  (void **)funcTab, 29);
	iki_vhdl_file_variable_register(dp + 16008);
	iki_vhdl_file_variable_register(dp + 16064);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/FSM_Main_tb_v2_behav/xsim.reloc");
}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/FSM_Main_tb_v2_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstatiate();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/FSM_Main_tb_v2_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/FSM_Main_tb_v2_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/FSM_Main_tb_v2_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
