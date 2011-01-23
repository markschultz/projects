################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../msp430x20x3_1.c 

CMD_SRCS += \
../lnk_msp430f2013.cmd 

OBJS += \
./msp430x20x3_1.obj 

C_DEPS += \
./msp430x20x3_1.pp 

OBJS__QTD += \
".\msp430x20x3_1.obj" 

C_DEPS__QTD += \
".\msp430x20x3_1.pp" 

C_SRCS_QUOTED += \
"../msp430x20x3_1.c" 


# Each subdirectory must supply rules for building sources it contributes
msp430x20x3_1.obj: ../msp430x20x3_1.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/msp430/bin/cl430" -vmsp -g --define=__MSP430F2013__ --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/msp430/include" --include_path="C:/Program Files (x86)/Texas Instruments/ccsv4/tools/compiler/msp430/include" --diag_warning=225 --printf_support=minimal --preproc_with_compile --preproc_dependency="msp430x20x3_1.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '


