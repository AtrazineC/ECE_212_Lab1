/* DO NOT MODIFY THIS --------------------------------------------*/
.text

.global AssemblyProgram

AssemblyProgram:
lea      -40(%a7),%a7 /*Backing up data and address registers */
movem.l %d2-%d7/%a2-%a5,(%a7)
/*----------------------------------------------------------------*/

/******************************************************************/
/* General Information ********************************************/
/* File Name: Lab1b.s *********************************************/
/* Names of Students: Lora Ma and Benjamin Kong                   **/
/* Date: 7 February 2020                                         **/
/* General Description:                                          **/
/* Convert ASCII char from uppercase to lowercase and lowercase  **/
   to uppercase                                                  **/
/******************************************************************/

move.l #0x43000000, %a2      /* address of values to convert */
move.l #0x43200000, %a3      /* address of converted values to be stored */
move.l #100, %d7             /* amount of iterations for loop */


/* repeat: main loop. Checks each input and converts if possible. */
repeat:
move.l (%a2), %d2            /* move value from address into data register */
move.l %d2, (%a3)            /* move value in data register into address */
cmpi.l #0x0d, %d2            /* enter key pressed => exit */
beq done                     /* exits if enter key was pressed */

cmpi.l #0x41, %d2            /* compare the value to hex 'A' */
blt error                    /* not a valid character */

cmpi.l #0x5A, %d2            /* compare the value to hex 'Z' */
bgt lower                    /* go to lower */

move.l #0x20, %d2            /* move value to data register */
add.l %d2, (%a3)             /* add value in data register to address */
bra check                    /* check if done iterating */


/* lower: checks if it's a lowercase ascii character */
lower:
cmpi.l #0x61, %d2            /*compare the value to hex 'a' */
blt error                    /* not a valid character; go to error */
cmpi.l #0x7A, %d2            /* compare the value to hex 'z' */
bgt error                    /* go to lower*/
move.l #0x20, %d2            /*move value to data register*/
sub.l %d2, (%a3)             /* subtract data register and address value */
bra check                    /* go to check */


/* check: checks if done iterating */
check:
add.l #4, %a2                /* increment address by one long word */
add.l #4, %a3                /* increment address by one long word */
sub.l #1, %d7                /* subtract value from data register */
cmp.l #0, %d7                /* compare value with data register */
beq done                     /* if equal, exit loop and go to done */
bra repeat                   /* else repeat loop */


/* error: moves error code to memory location */
error:
move.l #0xFFFFFFFF, (%a3)    /* move error code into memory location */
add.l #4, %a2                /* increment address by one long word */
add.l #4, %a3                /* increment address by one long word */
sub.l #1, %d7                /* subtract value from data register */
cmp.l #0, %d7                /* compare value with data register */
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