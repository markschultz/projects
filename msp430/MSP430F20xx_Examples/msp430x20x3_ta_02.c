//******************************************************************************
//  MSP430F20xx Demo - Timer_A, Toggle P1.0, CCR0 Up Mode ISR, DCO SMCLK
//
//  Description: Toggle P1.0 using software and TA_0 ISR. Timer_A is
//  configured for up mode, thus the timer overflows when TAR counts to CCR0.
//  In this example CCR0 is loaded with 50000.
//  ACLK = n/a, MCLK = SMCLK = TACLK = default DCO
//
//
//           MSP430F20xx
//         ---------------
//     /|\|            XIN|-
//      | |               |
//      --|RST        XOUT|-
//        |               |
//        |           P1.0|-->LED
//
//  M. Buccini / L. Westlund
//  Texas Instruments Inc.
//  October 2005
//  Built with CCE Version: 3.2.0 and IAR Embedded Workbench Version: 3.40A
//******************************************************************************

#include <msp430x20x3.h>

void main(void)
{
  WDTCTL = WDTPW + WDTHOLD;                 // Stop WDT
  P1DIR |= 0x01;                            // P1.0 output
  CCTL0 = CCIE;                             // CCR0 interrupt enabled
  CCR0 = 50000;
  TACTL = TASSEL_2 + MC_1;                  // SMCLK, upmode

  _BIS_SR(LPM0_bits + GIE);                 // Enter LPM0 w/ interrupt
}

// Timer A0 interrupt service routine
#pragma vector=TIMERA0_VECTOR
__interrupt void Timer_A (void)
{
  P1OUT ^= 0x01;                            // Toggle P1.0
}

