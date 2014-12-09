#include <stdio.h>
#include <stdlib.h>
int main(){

	char card_name[3];
	int count=0;

	do{

		puts("输入牌名：");
		scanf("%2s",card_name);
		int val=0;
		switch(card_name[0]){

			case 'K':
			case 'Q':
			case 'J':
				val = 10;
				break;
			case 'A':
				val = 11;
				break;
		    case 'X':
		    case 'x':
		        puts("Game Over!");
			    return 0;
			default:
				val = atoi(card_name);
				break;
		}
				

		if(val>11)
		{
			printf("错误的输入:%i\n",val);
			continue;
		}else
			printf("当前牌的点数为:%i\n",val);

		if(val>2 && val<7)
			count++;
		else if(val==10)
			count--;
		
		printf("当前计数:%i\n",count);
		  

	}while(1);
		  

	return 0;

}
