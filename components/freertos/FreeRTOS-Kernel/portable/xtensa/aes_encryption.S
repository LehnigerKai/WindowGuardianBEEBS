/*########################################################################################
This file contains the assembly code for encryption, storage of cipher text and
an integrity check that retrieves the stored cipher text and compares it with
calculated cipher text values.
#########################################################################################*/


#include "xtensa_rtos.h"

.global re_encryption				 	// declaring the encryption function as global makes it usable in xtensa_vectors.S file
.global ciphering						// (Either re_encryption or ciphering function is called inside overflow exception handler)
.global integrity_check
.global decryption

.literal_position
.align 4
   AES_MODE_REG: .word 0x3FF01008

.macro load_forReEncryption

	l32r a6, AES_START_REG  			// loading starting address for AES accelerator registers into register a6

	l32e a7, a9, -16					// loading value from a0
    s32i a7, a6, 0x30      				// storing the value of a0 into AES_TEXT_0_REG

	l32e a7, a9, -12					// loading value from a2
    s32i a7, a6, 0x34					// storing the value of a2 into AES_TEXT_1_REG

    l32e a7, a9, -8						// loading value from a3
    s32i a7, a6, 0x38					// storing the value of a3 into AES_TEXT_2_REG

	l32e a7, a9, -4		    			// loading value from a4
    s32i a7, a6, 0x3C					// storing the value of a4 into AES_TEXT_3_REG

.endm

.macro load_forCiphering
	l32r a6, AES_START_REG  			// loading starting address for AES accelerator registers into register a6

	l32e a7, a9, -16					// loading value from a0
    s32i a7, a6, 0x30      				// storing the value of a0 into AES_TEXT_0_REG

	l32e a7, a9, -8						// loading value from a2
    s32i a7, a6, 0x34					// storing the value of a2 into AES_TEXT_1_REG

    l32e a7, a9, -4						// loading value from a3
    s32i a7, a6, 0x38					// storing the value of a3 into AES_TEXT_2_REG

	l32e a7, a2, -32		    		// loading value from a4
    s32i a7, a6, 0x3C					// storing the value of a4 into AES_TEXT_3_REG
.endm

.macro crypto_operation

    movi a7, 1
    s32i a7, a6, 0        				// initializing AES_START_REG with 1
	memw
	.encryptWait_loop\@:
		l32i a7, a6, 0x4	  			// loading value of AES_IDLE_REG
		memw
   		beqz a7, .encryptWait_loop\@	// Waiting for encryption to end.
   										// (Loops as long as AES_IDLE_REG=0. Loop breaks when value of AES_IDLE_REG=1)
.endm

.macro save_ciphertext
	l32i  a5, a6, 0x30			 		// loading the cipher text present in AES_TEXT_0_REG
	s32e  a5, a9, -16			 		// save a0 to call[j+1]'s stack frame

	l32i  a5, a6, 0x34			 		// loading the cipher text present in AES_TEXT_1_REG
    s32e  a5, a9,  -8     		 		// save a2 to call[j+1]'s stack frame

	l32i  a5, a6, 0x38			 		// loading the cipher text present in AES_TEXT_2_REG
    s32e  a5, a9,  -4    		 		// save a3 to call[j+1]'s stack frame

	l32i  a5, a6, 0x3C			 		// loading the cipher text present in AES_TEXT_3_REG
    s32e  a5, a2, -32     		 		// save a4 to call[j]'s stack frame
.endm


.macro locate_storage

    getcoreid a5
    movi	a7, offset_ciphertext		// load the address of the variable(acting as enabled/disabled status indicator for aes accelerator )
	addx4   a7, a5, a7          		// navigating to the right index
	l32i.n  a7, a7, 0					// load the value of the offset_ciphertext global variable

	sub     a9, a9, a7					// navigating the stack using a specific offset value by decrementing the stack pointer

.endm

.macro store_ciphertext

	l32i a5, a6, 0x30			  		// loading the cipher text present in aes_text_0_reg
	s32e a5, a9, -16			  		// storing the cipher text to a location in stack(location is currently held by a9)

	l32i a5, a6, 0x34			  		// loading the cipher text present in aes_text_1_reg
	s32e a5, a9, -12

	l32i a5, a6, 0x38             		// loading the cipher text present in aes_text_2_reg
	s32e a5, a9, -8

	l32i a5, a6, 0x3C             		// loading the cipher text present in aes_text_3_reg
	s32e a5, a9, -4

	add     a9, a9, a7                	// moving the stack pointer back to its original value by incrementing the stack pointer

.endm

.text
crash_return:
	ill

.macro compare_ciphertext


	l32e a5, a9, -16					// loading the stored ciphertext of a0 from extended stack space
	l32i a7, a6, 0x30					// loading the latest ciphertext of a0
	bne  a5, a7, crash_return			// comparing the values loaded above

	l32e a5, a9, -12					// loading the stored ciphertext of a1 from extended stack space
	l32i a7, a6, 0x34					// loading the latest ciphertext of a1
	bne  a5, a7, crash_return			// comparing the values loaded above

	l32e a5, a9, -8						// loading the stored ciphertext of a2 from extended stack space
	l32i a7, a6, 0x38					// loading the latest ciphertext of a2
	bne  a5, a7, crash_return			// comparing the values loaded above

	l32e a5, a9, -4						// loading the stored ciphertext of a3 from extended stack space
	l32i a7, a6, 0x3C					// loading the latest ciphertext of a3
	bne  a5, a7, crash_return			// comparing the values loaded above

    getcoreid a5
    movi	a7, offset_ciphertext	    // load the address of the variable(acting as enabled/disabled status indicator for aes accelerator )
	addx4   a7, a5, a7                 	// navigating to the right index
	l32i.n  a7, a7, 0					// load the value of the offset_ciphertext global variable
	add     a9, a9, a7            		// moving the stack pointer to a specific offset value by decrementing the stack pointer

.endm

re_encryption:
	load_forReEncryption
	l32r 	a7, AES_MODE_REG
	movi 	a5, 0
	s32i 	a5, a7, 0
	crypto_operation
	locate_storage
	store_ciphertext

	j 		_WindowOverflow8_resume

ciphering:
	load_forCiphering
	l32r 	a7, AES_MODE_REG
	movi 	a5, 0
	s32i 	a5, a7, 0
	crypto_operation
	save_ciphertext

	j 		_WindowOverflow8_resume


integrity_check:
	load_forReEncryption
	l32r 	a7, AES_MODE_REG
	movi 	a5, 0
	s32i 	a5, a7, 0
	crypto_operation
	locate_storage
	compare_ciphertext
	j 	_WindowUnderflow8_resume


decryption:
	load_forCiphering
	l32r 	a7, AES_MODE_REG
	movi 	a5, 4
	s32i 	a5, a7, 0
	crypto_operation
	save_ciphertext
	j 		_WindowUnderflow8_resume


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//





