/* DO NOT MODIFY THIS --------------------------------------------*/
.text

.global AssemblyProgram

AssemblyProgram:
lea      -40(%a7),%a7 /*Backing up data and address registers */
movem.l %d2-%d7/%a2-%a5,(%a7)
/*----------------------------------------------------------------*/

/******************************************************************/
/* General Information ********************************************/
/* File Name: Lab1a.s *********************************************/
/* Names of Students: Lora Ma and Benjamin Kong                  **/
/* Date: 3 February 2020                                         **/
/* General Description: Converts Ascii characters to its         **/
/*                      hex/dec equivalent.                      **/
/******************************************************************/

move.l #0x43000000, %a2      /* address of values to convert */
move.l #0x43100000, %a3      /* adresss of converted values to be stored */
move.l #100, %d7             /* amount of iterations for loop */


/* repeat: main loop. Checks each input and converts if possible. */
repeat:
move.l (%a2), %d2            /* move value from address into data register */
move.l %d2, (%a3)            /* move value in data register into address */
cmpi.l #0x0d, %d2            /* enter key pressed => exit */
beq done                     /* exits if enter key was pressed */

cmpi.l #0x30, %d2            /* compares the value to hex '0' */
blt error                    /* not a valid character if less than 0 */
cmpi.l #0x39, %d2            /* compare the value to hex '9' */
bgt higher                   /* go to higher to keep testing */

move.l #0x30, %d2            /* move value into data register */
sub.l %d2, (%a3)             /* subtract data register value from address value */
bra check                    /* check if done iterating */


/* higher: checks if it's a uppercase ascii character */
higher:
cmpi.l #0x41, %d2            /* compare value to hex 'A' */
blt error                    /* not a valid character; go to error */
cmpi.l #0x46, %d2            /* compare the value to hex 'F' */
bgt lower                    /* go to lower to keep testing */
  
move.l #0x37, %d2            /* move value into data register */
sub.l %d2, (%a3)             /* subtract value from d2 to value in address */
bra check                    /* go to check */


/* lower: checks if it's a lowercase ascii character */
lower:
cmpi.l #0x61, %d2            /*compare the value to hex 'a' */
blt error                    /* not a valid character; go to error */
cmpi.l #0x66, %d2            / *compare the value to hex 'f' */
bgt error                    /* go to continue to keep testing */
move.l #0x57, %d2            /* move value to data register */
sub.l %d2, (%a3)             /* subtract d2 from value in address*/
bra check                    /* go to check */


/* check: checks if done iterating */
check:
add.l #4, %a2                /* increment address by one long word */
add.l #4, %a3                /* increment address by one long word */
sub.l #1, %d7                /* subtract 1 from data register */
cmp.l #0, %d7                /* see if 100 iterations are done */
beq done                     /* if yes, exit loop and go to done */
bra repeat                   /* else repeat loop */


/* error: moves error code to memory location */
error:
move.l #0xFFFFFFFF, (%a3)    /* move error code into memory location */
add.l #4, %a2                /* increment address by one long word */
add.l #4, %a3                /* increment address by one long word */
sub.l #1, %d7                /* subtract value from data register */
cmp.l #0, %d7                /* compare value with data register*/
beq done                     /* if equal, exit loop and go to done */
bra repeat                   /* else repeat loop */


/* done: exit point of program */
done:


/*End of program **************************************************/

/* DO NOT MODIFY THIS --------------------------------------------*/
movem.l (%a7),%d2-%d7/%a2-%a5 /*Restore data and address registers */
lea      40(%a7),%a7 
rts
/*----------------------------------------------------------------*/