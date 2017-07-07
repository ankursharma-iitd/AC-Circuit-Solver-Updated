%{
	#include "assn5.h"
	#include<stdio.h>            
	#include<stdlib.h>
	#include<math.h>
	#include<complex.h>
	
%}
lumped_element		([ \t]*)([a-zA-Z0-9]+)(([ \t]*))(((((N|n)(E|e)(T|t)))([0-9]+))|(0))(([ \t]*))(((((N|n)(E|e)(T|t)))([0-9]+))|(0))(([ \t]*))(((([0-9]+)(.)?([0-9]*)))((MEG|[NMKUFP]))?)([FH])?([ \t]*)
source_element		([ \t]*)([VI]([0-9]+))([ \t]*)(((((N|n)(E|e)(T|t)))([0-9]+))|(0))([ \t]*)(((((N|n)(E|e)(T|t)))([0-9]+))|(0))([ \t]*)(SINE)([ \t]*)([(]([ \t]*))(([0-9]+)(.)?([0-9]*))((MEG|[NMKUFP]))?([ \t]*)(([0-9]+)(.)?([0-9]*))((MEG|[NMKUFP]))?([ \t]*)((([0-9]+)(.)?([0-9]*))((MEG|[NMKUFP]))?([hH][z]))([ \t]*)(([0-9]+)(.)?([0-9]*))((MEG|[NMKUFP]))?(S)([ \t]*)((([0-9]+)(.)?([0-9]*))((MEG|[NMKUFP]))?)?([ \t]*)([)])([ \t]*)
%%
{lumped_element}	{

			if(lineNumber_total==0)
			{
				int pl;
				for(pl=0;pl<100;pl++)
				{
					nets[pl] = (Net2 *) malloc(sizeof(Net2));
					nets[pl]->count_of_sources=0;
					nets[pl]->count_of_components=0;
					nets[pl]->count_of_adjacent_lists=0;
				}
			}

			if(lineNumber==0)
			{
			componentArray=(Component*)malloc(1000*sizeof(Component));
			}



			componentArray[lineNumber].identifier=(char*)malloc(1000*sizeof(char));
			componentArray[lineNumber].net1=(Net*)malloc(1000*sizeof(Net));
			componentArray[lineNumber].net2=(Net*)malloc(1000*sizeof(Net));



			//adjusting the back spaces
			int len=yyleng;
			int mod=yyleng;

			while(mod>=0)
			{
			if(yytext[mod-1]!=' ')
				{
				len=mod;
				break;
				}
			mod--;
			}

			int i=0;
			while(yytext[i]==' ')
			{
				i++;
			}

			int count=1;

			(componentArray[lineNumber]).identifier[0]='X';

			while(yytext[i]!=' ')  //reads the component_name
			{
				(componentArray[lineNumber]).identifier[count]=yytext[i];
				i++;
				count++;
			}

			//printf("whut %s\n",componentArray[lineNumber].identifier);

			while(yytext[i]==' ')
				{
				i++;
				}
			//printf("%c %c %c %c %c\n",yytext[i],yytext[i+1],yytext[i+2],yytext[i+3],yytext[i+4]);

			count=0;
			(componentArray[lineNumber]).net1->net_name=0; //initial set
			(componentArray[lineNumber]).net2->net_name=0; //initial set

			int flag1=0,flag2=0,flag3=0;
			int adjust_pixels=0;

			//for the first terminal
			if(yytext[i]=='0' && yytext[i+1]==' ')
			{
				(componentArray[lineNumber]).net1->net_name=-1; // for ground
				(componentArray[lineNumber]).net1->xCord=20.00; // for ground
				(componentArray[lineNumber]).net1->yCord=0.00; // for ground
				i++;
				flag3=1;

			}
			else
			{
				if((yytext[i]=='N'||yytext[i]=='n') && (yytext[i+1]=='E'||yytext[i+1]=='e') && (yytext[i+2]=='T'||yytext[i+2]=='t'))
				{
					flag3=1;
				}
				while(yytext[i]!=' ')
				{
				if(yytext[i]=='n'|| yytext[i]=='e' || yytext[i]=='t' || yytext[i]=='N' || yytext[i]=='E' || yytext[i]=='T')
					{
					i++;
					flag1++;
					continue;
					}
				(componentArray[lineNumber]).net1->net_name=((componentArray[lineNumber]).net1->net_name)*10 + (yytext[i]-'0');
				i++;
				}
				(componentArray[lineNumber]).net1->xCord=((componentArray[lineNumber]).net1->net_name + 1)*100.00+20.0;
				(componentArray[lineNumber]).net1->yCord=0.00;
			}

			if(flag3==0)
				{
				fprintf(yyout, "Wrong Format for the terminal\n");
				//exit(1);
				}

			while(yytext[i]==' ')
				{
				i++;
				}


			// for the second terminal
			flag3=0;
			if(yytext[i]=='0' && yytext[i+1]==' ')
			{
				(componentArray[lineNumber]).net2->net_name=-1; // for ground
				i++;
				flag3=1;
				(componentArray[lineNumber]).net2->xCord=20.00; // for ground
				(componentArray[lineNumber]).net2->yCord=0.00; // for ground
			}
			else
			{
				if((yytext[i]=='N'||yytext[i]=='n') && (yytext[i+1]=='E'||yytext[i+1]=='e') && (yytext[i+2]=='T'||yytext[i+2]=='t'))
				{
					flag3=1;
				}
				while(yytext[i]!=' ')
				{
				if(yytext[i]=='n'|| yytext[i]=='e' || yytext[i]=='t' || yytext[i]=='N' || yytext[i]=='E' || yytext[i]=='T')
					{
					i++;
					flag2++;
					continue;
					}
				(componentArray[lineNumber]).net2->net_name=((componentArray[lineNumber]).net2->net_name)*10 + (yytext[i]-'0');
				i++;
				}
				(componentArray[lineNumber]).net2->xCord=((componentArray[lineNumber]).net2->net_name+1)*100.00+20.0;
				(componentArray[lineNumber]).net2->yCord=0.00;
			}

			if(flag3==0)
				{
				fprintf(yyout, "Wrong Format for the terminal\n");
				//exit(1);
				}

			if((flag1==0 && flag2==0) || ((componentArray[lineNumber]).net1->net_name)==((componentArray[lineNumber]).net2->net_name))
				{
				fprintf(yyout, "Wrongly Connected or Invalid format Netlist \n");
				//exit(1);
				}


			//printf("yayy %d %d\n",(componentArray[lineNumber]).net1->net_name,(componentArray[lineNumber]).net2->net_name);
			//exit(1);
			while(yytext[i]==' ')
				{
				i++;
				}

			(componentArray[lineNumber]).value=0.0; //initial default value set
			int decimal_point=-1; //get decimal point position
			count=0;

			int check_point=0;
			//printf("bitchhhh%c %c %c %c %c\n",yytext[i],yytext[i+1],yytext[i+2],yytext[i+3],yytext[i+4]);
			while((yytext[i]>='0' && yytext[i]<='9') || (yytext[i]=='.'))
			{
			//get the decimal point if any
			if(yytext[i]=='.')
				{
				decimal_point=i;
				count=1;
				}

			//if no decimal
			if(decimal_point==-1 && yytext[i]>='0' && yytext[i]<='9')
				{
				//printf("ofc  %d\n",yytext[i]);
				(componentArray[lineNumber]).value = (componentArray[lineNumber]).value*10.0 + (yytext[i]-'0')*1.0;
				}
			else if( decimal_point!=-1 && yytext[i]>='0' && yytext[i]<='9')//if decimal
				{
				(componentArray[lineNumber]).value = (componentArray[lineNumber]).value + ((yytext[i]-'0')/pow(10.0,count*1.0));
				count++;
				}
			//printf("whattt %lf\n",(componentArray[lineNumber]).value);

			i++;
			}
			//printf("WHatttttttttttttttttttt %d %c %c %c %c \n",i,yytext[i],yytext[i+1],yytext[i+2],yytext[i+3]);
			//printf("PLEASE %d %c \n",i,yytext[i]);
			//exit(1);

			//checking N/M/K/F/P/MEG/U
			check_point=i-1;
			if(yytext[i]=='N' || yytext[i]=='K' || yytext[i]=='F' || yytext[i]=='P' || yytext[i]=='U' )
				{
				check_point=i;
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				check_point=i+2;
				}
			else if(yytext[i]=='M')
				{
				check_point=i;
				}



			if(yytext[i]=='N')
				{
				(componentArray[lineNumber]).value = (componentArray[lineNumber]).value/pow(10.0,9.0);
				//printf("Final Value should be this -> %lf\n",(componentArray[lineNumber]).value);
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				(componentArray[lineNumber]).value = (componentArray[lineNumber]).value*1000000.0;
				//printf("Final Value should be this -> %lf\n",(componentArray[lineNumber]).value);
				}
			else if(yytext[i]=='M')
				{
				(componentArray[lineNumber]).value = (componentArray[lineNumber]).value/1000.0;
				}
			else if(yytext[i]=='K')
				{
				//printf("Initial Value should be this -> %lf\n",(componentArray[lineNumber]).value);
				(componentArray[lineNumber]).value = (componentArray[lineNumber]).value*1000.0;
				}
			else if(yytext[i]=='F')
				{
				(componentArray[lineNumber]).value = (componentArray[lineNumber]).value/pow(10.0,15.0);
				}
			else if(yytext[i]=='U')
				{
				(componentArray[lineNumber]).value = (componentArray[lineNumber]).value/pow(10.0,6.0);
				}
			else if(yytext[i]=='P')
				{
				(componentArray[lineNumber]).value = (componentArray[lineNumber]).value/pow(10.0,12.0);
				}

		//	printf("Value : %llf",(componentArray[lineNumber]).value);

			i=check_point;
			//printf("check point %d \n",check_point);
			//printf("plij %d\n",len);
			//printf("NIGGA %d %c\n",i,yytext[i]);
			if((i+1==len))
				{
				(componentArray[lineNumber]).identifier[0]='R';
				fprintf(yyout, "Resistor Accepted \n");
				}
			else if(yytext[i+1]=='H')
				{
				(componentArray[lineNumber]).identifier[0]='L';
				fprintf(yyout, "Inductor Accepted \n");
				}
			else if(yytext[i+1]=='F')
				{
				(componentArray[lineNumber]).identifier[0]='C';
				fprintf(yyout, "Capacitor Accepted\n");
				}


				int x=-1,y=-1;
					for(i=0;i<number_of_nets;i++)
					{
						if((nets[i]->n->net_name)==(componentArray[lineNumber].net1->net_name))
							x=i;
						else if((nets[i]->n->net_name)==(componentArray[lineNumber].net2->net_name))
							y=i;
					}


			if(x==-1)
				{
					//printf("bitchhhh x %d y %d \n",x,y);
					x=number_of_nets;
					if(y==-1)
					{
						y=number_of_nets+1;
						/*(componentArray[lineNumber].net1)->id=net_id;
						net_id++;
						(componentArray[lineNumber].net2)->id=net_id;
						net_id++;*/
						nets[x]->n=(componentArray[lineNumber].net1);
						nets[x]->comp_list[nets[x]->count_of_components]=&(componentArray[lineNumber]);
						nets[x]->count_of_components+=1;

						nets[y]->n=(componentArray[lineNumber].net2);
						nets[y]->comp_list[nets[y]->count_of_components]=&(componentArray[lineNumber]);
						nets[y]->count_of_components+=1;

						//printf("bitchhhh x %d y %d name %d id %d name %d id %d \n",x,y,nets[x]->n->net_name,nets[y]->n->id,nets[y]->n->net_name,nets[y]->n->id);
						number_of_nets+=2;
					}
					else
					{

						//(componentArray[lineNumber].net1)->id=net_id;
					//	net_id++;
						nets[x]->n=(componentArray[lineNumber].net1);
						nets[x]->comp_list[nets[x]->count_of_components]=&(componentArray[lineNumber]);
						nets[x]->count_of_components+=1;

						nets[y]->n=(componentArray[lineNumber].net2);
						nets[y]->comp_list[nets[y]->count_of_components]=&(componentArray[lineNumber]);
						nets[y]->count_of_components+=1;
						//printf("bitchhhh x %d y %d name %d id %d name %d id %d \n",x,y,nets[x]->n->net_name,nets[y]->n->id,nets[y]->n->net_name,nets[y]->n->id);
						number_of_nets+=1;
					}

						nets[x]->adjacent_list[nets[x]->count_of_adjacent_lists]=(nets[y]->n);
						nets[y]->adjacent_list[nets[y]->count_of_adjacent_lists]=nets[x]->n;
						nets[x]->count_of_adjacent_lists+=1;
						nets[y]->count_of_adjacent_lists+=1;
				}
			else
				{
					//printf("bitchhhh x %d y %d \n",x,y);
					if(y==-1)
					{
						//(componentArray[lineNumber].net2)->id=net_id;
						//net_id++;
						y=number_of_nets;
						nets[x]->n=(componentArray[lineNumber].net1);
						nets[x]->comp_list[nets[x]->count_of_components]=&(componentArray[lineNumber]);
						nets[x]->count_of_components+=1;

						nets[y]->n=(componentArray[lineNumber].net2);
						nets[y]->comp_list[nets[y]->count_of_components]=&(componentArray[lineNumber]);
						nets[y]->count_of_components+=1;

						nets[x]->adjacent_list[nets[x]->count_of_adjacent_lists]=nets[y]->n;
						nets[y]->adjacent_list[nets[y]->count_of_adjacent_lists]=nets[x]->n;
						nets[x]->count_of_adjacent_lists+=1;
						nets[y]->count_of_adjacent_lists+=1;
						//printf("bitchhhh x %d y %d name %d id %d name %d id %d \n",x,y,nets[x]->n->net_name,nets[y]->n->id,nets[y]->n->net_name,nets[y]->n->id);
						number_of_nets+=1;
					}
					else
					{
						nets[x]->n=(componentArray[lineNumber].net1);
						nets[x]->comp_list[nets[x]->count_of_components]=&(componentArray[lineNumber]);
						nets[x]->count_of_components+=1;

						nets[y]->n=(componentArray[lineNumber].net2);
						nets[y]->comp_list[nets[y]->count_of_components]=&(componentArray[lineNumber]);
						nets[y]->count_of_components+=1;

						int zz,z=-1,pp;
						for(zz=0;zz<nets[x]->count_of_adjacent_lists;zz++)
							{
								for(pp=0;pp<nets[y]->count_of_adjacent_lists;pp++)
								{
									if(nets[x]->adjacent_list[zz]->net_name==nets[y]->adjacent_list[pp]->net_name)
									z=1;
								}
							}

						if(z==-1)
						{
						nets[x]->adjacent_list[nets[x]->count_of_adjacent_lists]=nets[y]->n;
						nets[y]->adjacent_list[nets[y]->count_of_adjacent_lists]=nets[x]->n;
						nets[x]->count_of_adjacent_lists+=1;
						nets[y]->count_of_adjacent_lists+=1;
						}

						//printf("bitchhhh x %d y %d name %d id %d name %d id %d \n",x,y,nets[x]->n->net_name,nets[y]->n->id,nets[y]->n->net_name,nets[y]->n->id);
					}

				}

			componentArray[lineNumber].elementid=lineNumber_total;
			nets[x]->visited_flag=0;
			nets[y]->stay_away_flag=0;

			lineNumber++;
			lineNumber_total++;
			}

{source_element}	{
			int check_point=0;
			if(lineNumber_src==0)
			{
			sourceArray=(Source*)malloc(1000*sizeof(Source));
			}

			if(lineNumber_total==0)
			{
				int pl;
				for(pl=0;pl<100;pl++)
				{
					nets[pl] = (Net2 *) malloc(sizeof(Net2));
					nets[pl]->count_of_sources=0;
					nets[pl]->count_of_components=0;
					nets[pl]->count_of_adjacent_lists=0;
				}
			}

			sourceArray[lineNumber_src].identifier=(char*)malloc(1000*sizeof(char));
			sourceArray[lineNumber_src].net1=(Net*)malloc(1000*sizeof(Net));
			sourceArray[lineNumber_src].net2=(Net*)malloc(1000*sizeof(Net));


			int i=0;
			while(yytext[i]==' ')
				{
				i++;
				}

			//adjusting the back spaces
			int len=yyleng;
			int mod=yyleng;

			while(mod>=0)
			{
			if(yytext[mod-1]!=' ')
				{
				len=mod;
				break;
				}
			mod--;
			}

			//Reads the voltage or current source
			int count=0;

			while(yytext[i]!=' ')  //reads the source_name
			{
			(sourceArray[lineNumber_src]).identifier[count]=yytext[i];
			if(yytext[i]=='V')
			{
				sourceArray[lineNumber_src].voltageID=number_of_voltSources;
				number_of_voltSources++;

			}
			else if(yytext[i]=='I')
			{
				sourceArray[lineNumber_src].voltageID=-1;
			}
			//printf("%c ",(sourceArray[lineNumber_src]).identifier[count]);
			i++;
			count++;
			}
			//exit(1);
			while(yytext[i]==' ') //skips white spaces
				{
				i++;
				}

			count=0;
			(sourceArray[lineNumber_src]).net1->net_name=0; //initial set
			(sourceArray[lineNumber_src]).net2->net_name=0; //initial set
			int flag1=0,flag2=0,flag3=0;


			//for the first terminal
			if(yytext[i]=='0' && yytext[i+1]==' ')
			{
				(sourceArray[lineNumber_src]).net1->net_name=-1; // for ground
				i++;
				flag3=1;
				(sourceArray[lineNumber_src]).net1->xCord=20.00; // for ground
				(sourceArray[lineNumber_src]).net1->yCord=0.00; // for ground
			}
			else
			{
				if((yytext[i]=='N' || yytext[i]=='n') && (yytext[i+1]=='E' || yytext[i+1]=='e') && (yytext[i+2]=='T' || yytext[i+2]=='t'))
				{
					flag3=1;
				}
				while(yytext[i]!=' ')
				{
				if(yytext[i]=='n'|| yytext[i]=='e' || yytext[i]=='t' || yytext[i]=='N' || yytext[i]=='E' || yytext[i]=='T')
					{
					i++;
					flag1++;
					continue;
					}
				(sourceArray[lineNumber_src]).net1->net_name=((sourceArray[lineNumber_src]).net1->net_name)*10 + (yytext[i]-'0');
				i++;
				}
				(sourceArray[lineNumber_src]).net1->xCord=((sourceArray[lineNumber_src]).net1->net_name + 1)*100.00+20.0;
				(sourceArray[lineNumber_src]).net1->yCord=0.00;
			}
			if(flag3==0)
				{
				fprintf(yyout, "Wrong Format for the terminal\n");
				//exit(1);
				}

			while(yytext[i]==' ')
				{
				i++;
				}

			flag3=0;
			// for the second terminal
			if(yytext[i]=='0' && yytext[i+1]==' ')
			{
				(sourceArray[lineNumber_src]).net2->net_name=-1; // for ground
				//printf("bt");
				i++;
				flag3=1;
				(sourceArray[lineNumber_src]).net2->xCord=20.00; // for ground
				(sourceArray[lineNumber_src]).net2->yCord=0.00; // for ground
			}
			else
			{
				if((yytext[i]=='N'||yytext[i]=='n') && (yytext[i+1]=='E'||yytext[i+1]=='e') && (yytext[i+2]=='T'||yytext[i+2]=='t'))
				{
					flag3=1;
				}

				while(yytext[i]!=' ')
				{
				if(yytext[i]=='n'|| yytext[i]=='e' || yytext[i]=='t' || yytext[i]=='N' || yytext[i]=='E' || yytext[i]=='T')
					{
					i++;
					flag2++;
					continue;
					}
				(sourceArray[lineNumber_src]).net2->net_name=((sourceArray[lineNumber_src]).net2->net_name)*10 + (yytext[i]-'0');
				i++;
				}
				(sourceArray[lineNumber_src]).net2->xCord=((sourceArray[lineNumber_src]).net2->net_name + 1)*100.00+20.0;
				(sourceArray[lineNumber_src]).net2->yCord=0.00;
			}

			if(flag3==0)
				{
				fprintf(yyout, "Wrong Format for the terminal\n");
				//exit(1);
				}


			if((flag1==0 && flag2==0) || ((sourceArray[lineNumber_src]).net1->net_name)==((sourceArray[lineNumber_src]).net2->net_name))
				{
				fprintf(yyout, "Wrongly Connected or Invalid format Netlist \n");
				//exit(1);
				}


			while(yytext[i]==' ')
				{
				i++;
				}

			if(yytext[i]=='S' && yytext[i+1]=='I' && yytext[i+2]=='N' && yytext[i+3]=='E')
				{
				i=i+4;
				}
			else{
				fprintf(yyout, "Wrong Source Function; it should be SINE\n");
				//exit(1);
			}

			while(yytext[i]==' ')
				{
				i++;
				}

			if(yytext[i]=='(')
				{
				i++;
				}
			else
				{
				fprintf(yyout, "Missing Bracket. Incorrect Format\n");
				//exit(1);
				}

			while(yytext[i]==' ')
				{
				i++;
				}
			int decimal_point;
			count=0;

			(sourceArray[lineNumber_src]).dc_offset=0.0;
			(sourceArray[lineNumber_src]).amplitude=0.0;
			(sourceArray[lineNumber_src]).frequency=0.0;
			(sourceArray[lineNumber_src]).delay=0.0;
			(sourceArray[lineNumber_src]).damping_factor=0.0;




			//get the dc_offset as a double value
			check_point=0;
			decimal_point=-1;
			count=0;
			while((yytext[i]>='0' && yytext[i]<='9') || (yytext[i]=='.'))
			{
			//get the decimal point if any
			if(yytext[i]=='.')
				{
				decimal_point=i;
				count=1;
				}

			//if no decimal
			if(decimal_point==-1 && yytext[i]>='0' && yytext[i]<='9')
				{
				//printf("ofc  %d\n",yytext[i]);
				(sourceArray[lineNumber_src]).dc_offset = (sourceArray[lineNumber_src]).dc_offset*10.0 + (yytext[i]-'0')*1.0;
				}
			else if( decimal_point!=-1 && yytext[i]>='0' && yytext[i]<='9')//if decimal
				{
				(sourceArray[lineNumber_src]).dc_offset = (sourceArray[lineNumber_src]).dc_offset + ((yytext[i]-'0')/pow(10.0,count*1.0));
				count++;
				}


			i++;
			}


			//checking N/M/K/F/P/MEG/U
			check_point=i-1;
			if(yytext[i]=='N' || yytext[i]=='K' || yytext[i]=='F' || yytext[i]=='P' || yytext[i]=='U' )
				{
				check_point=i;
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				check_point=i+2;
				}
			else if(yytext[i]=='M')
				{
				check_point=i;
				}



			if(yytext[i]=='N')
				{
				(sourceArray[lineNumber_src]).dc_offset = (sourceArray[lineNumber_src]).dc_offset/pow(10.0,9.0);
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				(sourceArray[lineNumber_src]).dc_offset = (sourceArray[lineNumber_src]).dc_offset*1000000.0;
				}
			else if(yytext[i]=='M')
				{
				(sourceArray[lineNumber_src]).dc_offset = (sourceArray[lineNumber_src]).dc_offset/1000.0;
				}
			else if(yytext[i]=='K')
				{
				(sourceArray[lineNumber_src]).dc_offset = (sourceArray[lineNumber_src]).dc_offset*1000.0;
				}
			else if(yytext[i]=='F')
				{
				(sourceArray[lineNumber_src]).dc_offset = (sourceArray[lineNumber_src]).dc_offset/pow(10.0,15.0);
				}
			else if(yytext[i]=='U')
				{
				(sourceArray[lineNumber_src]).dc_offset = (sourceArray[lineNumber_src]).dc_offset/pow(10.0,6.0);
				}
			else if(yytext[i]=='P')
				{
				(sourceArray[lineNumber_src]).dc_offset = (sourceArray[lineNumber_src]).dc_offset/pow(10.0,12.0);
				}

			i=check_point+1;

			while(yytext[i]==' ')
				{
				i++;
				}




//checking and storing the amplitude
			check_point=0;
			decimal_point=-1;
			count=0;
			while((yytext[i]>='0' && yytext[i]<='9') || (yytext[i]=='.'))
			{
			//get the decimal point if any
			if(yytext[i]=='.')
				{
				decimal_point=i;
				count=1;
				}

			//if no decimal
			if(decimal_point==-1 && yytext[i]>='0' && yytext[i]<='9')
				{
				//printf("ofc  %d\n",yytext[i]);
				(sourceArray[lineNumber_src]).amplitude = (sourceArray[lineNumber_src]).amplitude*10.0 + (yytext[i]-'0')*1.0;
				}
			else if( decimal_point!=-1 && yytext[i]>='0' && yytext[i]<='9')//if decimal
				{
				(sourceArray[lineNumber_src]).amplitude = (sourceArray[lineNumber_src]).amplitude + ((yytext[i]-'0')/pow(10.0,count*1.0));
				count++;
				}


			i++;
			}

			//checking N/M/K/F/P/MEG/U
			check_point=i-1;
			if(yytext[i]=='N' || yytext[i]=='K' || yytext[i]=='F' || yytext[i]=='P' || yytext[i]=='U' )
				{
				check_point=i;
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				check_point=i+2;
				}
			else if(yytext[i]=='M')
				{
				check_point=i;
				}



			if(yytext[i]=='N')
				{
				(sourceArray[lineNumber_src]).amplitude = (sourceArray[lineNumber_src]).amplitude/pow(10.0,9.0);
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				(sourceArray[lineNumber_src]).amplitude = (sourceArray[lineNumber_src]).amplitude*1000000.0;
				}
			else if(yytext[i]=='M')
				{
				(sourceArray[lineNumber_src]).amplitude = (sourceArray[lineNumber_src]).amplitude/1000.0;
				}
			else if(yytext[i]=='K')
				{
				(sourceArray[lineNumber_src]).amplitude = (sourceArray[lineNumber_src]).amplitude*1000.0;
				}
			else if(yytext[i]=='F')
				{
				(sourceArray[lineNumber_src]).amplitude = (sourceArray[lineNumber_src]).amplitude/pow(10.0,15.0);
				}
			else if(yytext[i]=='U')
				{
				(sourceArray[lineNumber_src]).amplitude = (sourceArray[lineNumber_src]).amplitude/pow(10.0,6.0);
				}
			else if(yytext[i]=='P')
				{
				(sourceArray[lineNumber_src]).amplitude = (sourceArray[lineNumber_src]).amplitude/pow(10.0,12.0);
				}

			i=check_point+1;




			while(yytext[i]==' ')
				{i++;}




//getting and storing the frequency
			check_point=0;
			decimal_point=-1;
			count=0;
			while((yytext[i]>='0' && yytext[i]<='9') || (yytext[i]=='.'))
			{
			//get the decimal point if any
			if(yytext[i]=='.')
				{
				decimal_point=i;
				count=1;
				}

			//if no decimal
			if(decimal_point==-1 && yytext[i]>='0' && yytext[i]<='9')
				{
				//printf("ofc  %d\n",yytext[i]);
				(sourceArray[lineNumber_src]).frequency = (sourceArray[lineNumber_src]).frequency*10.0 + (yytext[i]-'0')*1.0;
				}
			else if( decimal_point!=-1 && yytext[i]>='0' && yytext[i]<='9')//if decimal
				{
				(sourceArray[lineNumber_src]).frequency = (sourceArray[lineNumber_src]).frequency + ((yytext[i]-'0')/pow(10.0,count*1.0));
				count++;
				}


			i++;
			}

			//checking N/M/K/F/P/MEG/U
			check_point=i-1;
			if(yytext[i]=='N' || yytext[i]=='K' || yytext[i]=='F' || yytext[i]=='P' || yytext[i]=='U' )
				{
				check_point=i;
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				check_point=i+2;
				}
			else if(yytext[i]=='M')
				{
				check_point=i;
				}



			if(yytext[i]=='N')
				{
				(sourceArray[lineNumber_src]).frequency = (sourceArray[lineNumber_src]).frequency/pow(10.0,9.0);
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				(sourceArray[lineNumber_src]).frequency = (sourceArray[lineNumber_src]).frequency*1000000.0;
				}
			else if(yytext[i]=='M')
				{
				(sourceArray[lineNumber_src]).frequency = (sourceArray[lineNumber_src]).frequency/1000.0;
				}
			else if(yytext[i]=='K')
				{
				(sourceArray[lineNumber_src]).frequency = (sourceArray[lineNumber_src]).frequency*1000.0;
				}
			else if(yytext[i]=='F')
				{
				(sourceArray[lineNumber_src]).frequency = (sourceArray[lineNumber_src]).frequency/pow(10.0,15.0);
				}
			else if(yytext[i]=='U')
				{
				(sourceArray[lineNumber_src]).frequency = (sourceArray[lineNumber_src]).frequency/pow(10.0,6.0);
				}
			else if(yytext[i]=='P')
				{
				(sourceArray[lineNumber_src]).frequency = (sourceArray[lineNumber_src]).frequency/pow(10.0,12.0);
				}

			i=check_point+1;
			if((yytext[i]=='h' || yytext[i]=='H') && yytext[i+1]=='z')
			{
				i=i+2;
			}
			else
			{
			fprintf(yyout, "Incorrect units for frequency\n");
			//exit(1);
			}

			while(yytext[i]==' ')
				{i++;}

			// read the goddamn delay
			check_point=0;
			decimal_point=-1;
			count=0;
			while((yytext[i]>='0' && yytext[i]<='9') || (yytext[i]=='.'))
			{
			//get the decimal point if any
			if(yytext[i]=='.')
				{
				decimal_point=i;
				count=1;
				}

			//if no decimal
			if(decimal_point==-1 && yytext[i]>='0' && yytext[i]<='9')
				{
				//printf("ofc  %d\n",yytext[i]);
				(sourceArray[lineNumber_src]).delay = (sourceArray[lineNumber_src]).delay*10.0 + (yytext[i]-'0')*1.0;
				}
			else if( decimal_point!=-1 && yytext[i]>='0' && yytext[i]<='9')//if decimal
				{
				(sourceArray[lineNumber_src]).delay = (sourceArray[lineNumber_src]).delay + ((yytext[i]-'0')/pow(10.0,count*1.0));
				count++;
				}


			i++;
			}

			//checking N/M/K/F/P/MEG/U
			check_point=i-1;
			if(yytext[i]=='N' || yytext[i]=='K' || yytext[i]=='F' || yytext[i]=='P' || yytext[i]=='U' )
				{
				check_point=i;
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				check_point=i+2;
				}
			else if(yytext[i]=='M')
				{
				check_point=i;
				}



			if(yytext[i]=='N')
				{
				(sourceArray[lineNumber_src]).delay = (sourceArray[lineNumber_src]).delay/pow(10.0,9.0);
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				(sourceArray[lineNumber_src]).delay = (sourceArray[lineNumber_src]).delay*1000000.0;
				}
			else if(yytext[i]=='M')
				{
				(sourceArray[lineNumber_src]).delay = (sourceArray[lineNumber_src]).delay/1000.0;
				}
			else if(yytext[i]=='K')
				{
				(sourceArray[lineNumber_src]).delay = (sourceArray[lineNumber_src]).delay*1000.0;
				}
			else if(yytext[i]=='F')
				{
				(sourceArray[lineNumber_src]).delay = (sourceArray[lineNumber_src]).delay/pow(10.0,15.0);
				}
			else if(yytext[i]=='U')
				{
				(sourceArray[lineNumber_src]).delay = (sourceArray[lineNumber_src]).delay/pow(10.0,6.0);
				}
			else if(yytext[i]=='P')
				{
				(sourceArray[lineNumber_src]).delay = (sourceArray[lineNumber_src]).delay/pow(10.0,12.0);
				}

			i=check_point+1;

			if(yytext[i]=='S')
			{
			i++;
			}
			else
			{
			fprintf(yyout, "Wrong units of delay\n");
			//exit(1);
			}



			while(yytext[i]==' ')
			{
			i++;}

			if(yytext[i]==')')
				{
					fprintf(yyout, "Damping factor missing for the source. ");
					if((sourceArray[lineNumber_src]).identifier[0]=='V')
						{
						fprintf(yyout, "Voltage Source Accepted\n");
						}
					else
						{
						fprintf(yyout, "Current Source Accepted\n");
						}
				}
			else
				{
					//read the damping factor
			check_point=0;
			decimal_point=-1;
			count=0;
			while((yytext[i]>='0' && yytext[i]<='9') || (yytext[i]=='.'))
			{
			//get the decimal point if any
			if(yytext[i]=='.')
				{
				decimal_point=i;
				count=1;
				}

			//if no decimal
			if(decimal_point==-1 && yytext[i]>='0' && yytext[i]<='9')
				{
				//printf("ofc  %d\n",yytext[i]);
				(sourceArray[lineNumber_src]).damping_factor = (sourceArray[lineNumber_src]).damping_factor*10.0 + (yytext[i]-'0')*1.0;
				}
			else if( decimal_point!=-1 && yytext[i]>='0' && yytext[i]<='9')//if decimal
				{
				(sourceArray[lineNumber_src]).damping_factor = (sourceArray[lineNumber_src]).damping_factor + ((yytext[i]-'0')/pow(10.0,count*1.0));
				count++;
				}


			i++;
			}

			//checking N/M/K/F/P/MEG/U
			check_point=i-1;
			if(yytext[i]=='N' || yytext[i]=='K' || yytext[i]=='F' || yytext[i]=='P' || yytext[i]=='U' )
				{
				check_point=i;
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				check_point=i+2;
				}
			else if(yytext[i]=='M')
				{
				check_point=i;
				}



			if(yytext[i]=='N')
				{
				(sourceArray[lineNumber_src]).damping_factor = (sourceArray[lineNumber_src]).damping_factor/pow(10.0,9.0);
				}
			else if((yytext[i]=='M' && yytext[i+1]=='E' && yytext[i+2]=='G'))
				{
				(sourceArray[lineNumber_src]).damping_factor = (sourceArray[lineNumber_src]).damping_factor*1000000.0;
				}
			else if(yytext[i]=='M')
				{
				(sourceArray[lineNumber_src]).damping_factor = (sourceArray[lineNumber_src]).damping_factor/1000.0;
				}
			else if(yytext[i]=='K')
				{
				(sourceArray[lineNumber_src]).damping_factor = (sourceArray[lineNumber_src]).damping_factor*1000.0;
				}
			else if(yytext[i]=='F')
				{
				(sourceArray[lineNumber_src]).damping_factor = (sourceArray[lineNumber_src]).damping_factor/pow(10.0,15.0);
				}
			else if(yytext[i]=='U')
				{
				(sourceArray[lineNumber_src]).damping_factor = (sourceArray[lineNumber_src]).damping_factor/pow(10.0,6.0);
				}
			else if(yytext[i]=='P')
				{
				(sourceArray[lineNumber_src]).damping_factor = (sourceArray[lineNumber_src]).damping_factor/pow(10.0,12.0);
				}

			i=check_point+1;

			//printf("%lf %lf %lf %lf %lf \n",(sourceArray[lineNumber_src]).dc_offset,(sourceArray[lineNumber_src]).amplitude,(sourceArray[lineNumber_src]).frequency,(sourceArray[lineNumber_src]).delay,(sourceArray[lineNumber_src]).damping_factor);


			while(yytext[i]==' ')
			{i++;}

			if(yytext[i]==')')
			{
			i++;}
			else
			{
			fprintf(yyout, "Incorrect format\n");
			//exit(1);
			}

			//printf("Yayyyyy\n");
			if((sourceArray[lineNumber_src]).identifier[0]=='V')
				{
					fprintf(yyout, "Voltage Source Accepted\n");
				}
			else
				{
					fprintf(yyout, "Current Source Accepted\n");
				}
				}


				int x=-1,y=-1;
					for(i=0;i<number_of_nets;i++)
					{
						if((nets[i]->n->net_name)==(sourceArray[lineNumber_src].net1->net_name))
							x=i;
						else if((nets[i]->n->net_name)==(sourceArray[lineNumber_src].net2->net_name))
							y=i;
					}

			if(x==-1)
				{
					x=number_of_nets;
					if(y==-1)
					{
						y=number_of_nets+1;
						nets[x]->n=(sourceArray[lineNumber_src].net1);
						nets[x]->source_list[nets[x]->count_of_sources]=&(sourceArray[lineNumber_src]);
						nets[x]->count_of_sources+=1;

						nets[y]->n=(sourceArray[lineNumber_src].net2);
						nets[y]->source_list[nets[y]->count_of_sources]=&(sourceArray[lineNumber_src]);
						nets[y]->count_of_sources+=1;
						/*nets[x]->n->id=net_id;
						net_id++;
						nets[y]->n->id=net_id;
						net_id++;*/

						number_of_nets+=2;
					}
					else
					{
						nets[x]->n=(sourceArray[lineNumber_src].net1);
						nets[x]->source_list[nets[x]->count_of_sources]=&(sourceArray[lineNumber_src]);
						nets[x]->count_of_sources+=1;

						nets[y]->n=(sourceArray[lineNumber_src].net2);
						nets[y]->source_list[nets[y]->count_of_sources]=&(sourceArray[lineNumber_src]);
						nets[y]->count_of_sources+=1;
						//nets[x]->n->id=net_id;
						//net_id++;

						number_of_nets+=1;
					}
				}
			else
				{
					if(y==-1)
					{
						y=number_of_nets;
						nets[x]->n=(sourceArray[lineNumber_src].net1);
						nets[x]->source_list[nets[x]->count_of_sources]=&(sourceArray[lineNumber_src]);
						nets[x]->count_of_sources+=1;

						nets[y]->n=(sourceArray[lineNumber_src].net2);
						nets[y]->source_list[nets[y]->count_of_sources]=&(sourceArray[lineNumber_src]);
						nets[y]->count_of_sources+=1;
						//nets[y]->n->id=net_id;
						//net_id++;

						number_of_nets+=1;
					}
					else
					{
						nets[x]->n=(sourceArray[lineNumber_src].net1);
						nets[x]->source_list[nets[x]->count_of_sources]=&(sourceArray[lineNumber_src]);
						nets[x]->count_of_sources+=1;

						nets[y]->n=(sourceArray[lineNumber_src].net2);
						nets[y]->source_list[nets[y]->count_of_sources]=&(sourceArray[lineNumber_src]);
						nets[y]->count_of_sources+=1;
					}

				}

			nets[x]->visited_flag=0;
			nets[y]->stay_away_flag=0;

			sourceArray[lineNumber_src].elementid=lineNumber_total;

			lineNumber_src++;
			lineNumber_total++;
			}

(.)*		{fprintf(yyout, "Syntax error in the format. Please check again.\n");}


%%
int yywrap(void)
{
    return 1;
}


int main(int argc, char *argv[]) {
	if(argc!= 4){
		printf("Not enough arguments, exiting!");
		exit(-1);
	}

    yyin = fopen(argv[1], "r");
    yyout = fopen("output.txt", "w");
    yylex();
    FILE *fptr = fopen(argv[2], "w");
    //Nets will be starting from 20 pixels and will be spaced 40 pixels apart. start y-coordinate at
    //say 200 pixels ?

    int i,p;
 		for(i=0;i<number_of_nets;i++)
    	{
    		printf("Components adjacent to this %d are : ",nets[i]->n->net_name);
    		for(p=0;p<nets[i]->count_of_components;p++)
    		{
    			printf("%s, ",nets[i]->comp_list[p]->identifier);
    		}
    		printf("\n");

    		if(nets[i]->count_of_sources!=0)
    		printf("Sources adjacent to this %d are : ",nets[i]->n->net_name);
    		for(p=0;p<nets[i]->count_of_sources;p++)
    		{
    			printf("%s, ",nets[i]->source_list[p]->identifier);
    		}
    		printf("\n");

    		if(nets[i]->count_of_adjacent_lists!=0)
    		printf("Nets adjacent to this %d are : ",nets[i]->n->net_name);
    		for(p=0;p<nets[i]->count_of_adjacent_lists;p++)
    		{
    			printf("%d, ",nets[i]->adjacent_list[p]->net_name);
    		}
    		printf("\n");
    	}


    fprintf(fptr, 

    		"<svg\n"
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\"\n"
            "   xmlns:cc=\"http://creativecommons.org/ns#\"\n"
            "   xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"
            "   xmlns:svg=\"http://www.w3.org/2000/svg\"\n"
            "   xmlns=\"http://www.w3.org/2000/svg\"\n"
            "   xmlns:sodipodi=\"http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd\"\n"
            "   xmlns:inkscape=\"http://www.inkscape.org/namespaces/inkscape\"\n"
            "   xmlns:xlink=\"http://www.w3.org/1999/xlink\"\n"
            "   id=\"svg2\"\n"
            "   version=\"1.0\"\n"
            "   inkscape:output_extension=\"org.inkscape.output.svg.inkscape\"\n"
            "   inkscape:export-filename=\"logic_gates.png\"\n"
            "   inkscape:export-xdpi=\"434.31\"\n"
            "   inkscape:export-ydpi=\"434.31\"\n"
            "   inkscape:version=\"0.48.1 r9760\"\n"
            "   width=\"10000\"\n"
            "   height=\"10000\"\n"
            "   sodipodi:docname=\"basic_logic_gates_not.svg\">\n"
            "<script xlink:href=\"svgpan.js\"/> \n"
            "<g transform = \"translate(100,300)\" id=\"viewport\">");



	i=0;
    p=0;
    //Prints sources

    //Prints the components at the X and Y position
    double groundxCord =0;
    double groundyCord =0;
    int flagGND = 0;
    for(p=0; p<lineNumber; p++) {
        Component *now = &componentArray[p];
        double xCord = (now->net1->xCord + now->net2->xCord)/2;
        double yCord = (i%2==1) ? (((1.0*i + 1.0)/2.0)*PIXEL_Y) : ((-(1.0*i)/2.0)*PIXEL_Y);
        now->xPlace = xCord;
        now->yPlace = yCord;
        if(flagGND != -1) {
            if (now->net1->net_name == -1) {
                groundxCord = now->net1->xCord;
                groundyCord = now->net1->yCord;
                flagGND = -1;
            }
            if (now->net2->net_name == -1) {
                groundxCord = now->net2->xCord;
                groundyCord = now->net2->yCord;
                flagGND = -1;
            }
        }
        printComponent(now, fptr, xCord, yCord);
        i++;
    }
    for(p=0; p<lineNumber_src; p++) {
        Source *now = &sourceArray[p];
        double xCord = (now->net1->xCord + now->net2->xCord)/2;
        double yCord = (i%2==1) ? (((1.0*i + 1.0)/2.0)*PIXEL_Y) : ((-(1.0*i)/2.0)*PIXEL_Y);
        now->xPlace = xCord;
        now->yPlace = yCord;
        printSource(now, fptr, xCord, yCord);
        i++;
    }

    //now to print connections
    for(p=0; p<lineNumber; p++) {
        Component now = componentArray[p];
        double xLeft = now.net1->xCord;
        double xRight = now.net2->xCord;
        if (xLeft > xRight){
            double temp = xLeft;
            xLeft = xRight;
            xRight = temp;
        }
        double yLeft = now.net1->yCord;
        double yRight = now.net2->yCord;
        switch(now.identifier[0]){
            case 'R' :
                fprintf(fptr, "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n"
                                "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n", now.xPlace + 1.0-18.5, now.yPlace + 2.5-3, xLeft, now.yPlace + 2.5-3,
                        now.xPlace + 38.0-18.5, now.yPlace + 2.5-3, xRight, now.yPlace + 2.5-3);
                fprintf(fptr, "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n"
                                "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n", xLeft, now.yPlace + 3.5-3, xLeft,yLeft,
                        xRight, now.yPlace + 3.5-3, xRight, yRight);
                //^extremely exhausting code to write, thanks for the labour work ankur -.-
                break;
            case 'L' :
                fprintf(fptr, "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n"
                                "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />", now.xPlace + 1.0-21.5, now.yPlace + 8.5-10, xLeft, now.yPlace + 8.5-10,
                        now.xPlace + 44.0-21.5, now.yPlace + 8.5-10, xRight, now.yPlace + 8.5-10);
                fprintf(fptr, "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n"
                                "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />", xLeft, now.yPlace + 8.5-10, xLeft,yLeft,
                        xRight, now.yPlace + 8.5-10, xRight, yRight);
                break;
            case 'C' :
                fprintf(fptr, "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n"
                                "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />", now.xPlace-17.5, now.yPlace + 16.0-10.5, xLeft, now.yPlace + 16.0-10.5,
                        now.xPlace + 35.0-17.5, now.yPlace + 16-10.5, xRight, now.yPlace + 16-10.5);
                fprintf(fptr, "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n"
                                "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />", xLeft, now.yPlace + 16.0-10.5, xLeft,yLeft,
                        xRight, now.yPlace + 16.0-10.5, xRight, yRight);
                break;
            default:
                break;
        }
    }

    for(p=0; p<lineNumber_src; p++) {
        Source now = sourceArray[p];
        double xLeft = now.net1->xCord;
        double xRight = now.net2->xCord;
        if (xLeft > xRight){
            double temp = xLeft;
            xLeft = xRight;
            xRight = temp;
        }
        double yLeft = now.net1->yCord;
        double yRight = now.net2->yCord;
        switch(now.identifier[0]){
            case 'V' :
                fprintf(fptr, "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n"
                                "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />", now.xPlace -1.5 -10 , now.yPlace + 9.7865725, xLeft, now.yPlace + 9.7865725,
                        now.xPlace + 18.5-10, now.yPlace + 9.7865725, xRight, now.yPlace + 9.7865725);
                fprintf(fptr, "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n"
                                "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />", xLeft, now.yPlace + 9.7865725, xLeft,yLeft,
                        xRight, now.yPlace + 9.7865725, xRight, yRight);
                //^extremely exhausting code to write, thanks for the labour work ankur -.-
                break;
            case 'I' :
                fprintf(fptr, "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n"
                                "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />", now.xPlace + 10.0-15, now.yPlace + 26.02439-10, xLeft, now.yPlace + 26.02439-10,
                        now.xPlace + 40.0-15, now.yPlace + 26.02439-10, xRight, now.yPlace + 26.02439-10);
                fprintf(fptr, "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />\n"
                                "<line x1=\"%lf\" y1=\"%lf\" x2=\"%lf\" y2=\"%lf\" \n"
                                "stroke-width=\"1\" stroke=\"black\" />", xLeft, now.yPlace + 26.02439-10, xLeft,yLeft,
                        xRight, now.yPlace + 26.02439-10, xRight, yRight);
                break;
            default:
                break;
        }
    }

    //print ground symbol

    if(flagGND == -1) {
        fprintf(fptr, "<g\n"
                "     id=\"layer1\" transform=\"translate(%lf,%lf)rotate(90,0,0)scale(0.7)\">\n"
                "    <path\n"
                "       d=\"M 0.5,24.5 L 24.5,24.5\"\n"
                "       style=\"fill:none;fill-opacity:0.75;fill-rule:evenodd;stroke:#000000;stroke-width:1.5px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\"\n"
                "       id=\"path4098\" />\n"
                "    <path\n"
                "       d=\"M 4.5,27.5 L 20.5,27.5\"\n"
                "       style=\"fill:none;fill-opacity:0.75;fill-rule:evenodd;stroke:#000000;stroke-width:1.5px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\"\n"
                "       id=\"path4100\" />\n"
                "    <path\n"
                "       d=\"M 16.5,30.5 L 8.5,30.5\"\n"
                "       style=\"fill:none;fill-opacity:0.75;fill-rule:evenodd;stroke:#000000;stroke-width:1.5px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\"\n"
                "       id=\"path4102\" />\n"
                "    <path\n"
                "       d=\"M 12.5,24.5 L 12.5,4.5\"\n"
                "       style=\"fill:none;fill-opacity:0.75;fill-rule:evenodd;stroke:#000000;stroke-width:1.5px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\"\n"
                "       id=\"path4104\" />\n"
                "  </g>", groundxCord +3, groundyCord-9.5);
    }

    //print nets
    for(p=0; p<lineNumber; p++) {
        Component now = componentArray[p];

        int net_name = now.net1->net_name;
        fprintf(fptr, "\t <text x=\"%lf\" y=\"%lf\" font-size=\"6\" fill=\"black\" >\n"
                "\t\tNet%d\n"
                "\t</text>",now.net1->xCord + 2 , now.net1->yCord - 2,net_name);
    }

    fprintf(fptr," </g>"
            "</svg>");

    for(int i=0; i<lineNumber_src; i++) {
    	printf("%s", sourceArray[i].identifier);
    }

    //Now to proceed with solving the circuit

    /*for(int i=0; i<lineNumber; i++) {
    	printf("%s %d %d \n", componentArray[i].identifier, componentArray[i].net1, componentArray[i].net2);
    }*/
    double frequ = 0.0;
    int num_freq = 0;
    for(int i=0; i<lineNumber_src; i++) {
    	Source source = sourceArray[i];
    	double freq1 = source.frequency;
    	if(fabs(freq1 - frequ) > 0.0005){
    		num_freq++;
    		frequ = freq1;
      	}
    }
    frequ = 0.0;
    double freq_array[num_freq]; //contains omegas
    int cc=0;
    for(int i=0; i<lineNumber_src; i++) {
    	Source source = sourceArray[i];
    	double freq1 = source.frequency;
    	if(fabs(freq1 - frequ) > 0.0005){
    		freq_array[cc] = 2*M_PI*freq1;
    		cc++;
    	}
    }

    //sort by increasing frequency

    for(int i=0; i<num_freq-1;i++)
    {
    	for(int j=i+1;j<num_freq;j++)
    	{
    		if(freq_array[i]>freq_array[j]){    			//swap
    			double temp = freq_array[i];
    			freq_array[i] = freq_array[j];
    			freq_array[j] = temp;
    		}
    	}
    }
    FILE* fptr2 = fopen(argv[3], "w");
    for(int i=0; i<num_freq; i++) {
   		solveCircuit(number_of_nets,fptr,lineNumber,lineNumber_src,freq_array[i],fptr2);
	}
    return 0;


}

void solveCircuit(int number_of_nets, FILE *fptr, int num_components, int num_sources,double freq, FILE* fptr2){
  fprintf(fptr2, "FREQ = %.3lfKHz\n", freq/(1000.0*2.0*M_PI));
  double curr[number_of_nets+number_of_voltSources];
  double complex matrix[number_of_nets+number_of_voltSources][number_of_nets+number_of_voltSources +1],a;
  double complex var[number_of_nets+number_of_voltSources],b;
  for(int iterate = 0; iterate<1; iterate++) {
	//Source source_array_same_freq[num_sources][num_sources];

	
	
    double complex G[number_of_nets+number_of_voltSources][number_of_nets+number_of_voltSources];
    for(int i=0; i<number_of_nets+number_of_voltSources; i++) {
    	for(int j=0; j<number_of_nets+number_of_voltSources; j++) {
    		G[i][j] = 0.0 + 0.0 * I;
    	}
    }

    
	for(int j=0; j<number_of_nets+number_of_voltSources; j++) {
    	curr[j] = 0.0;
    }

	for(int i=0; i<number_of_nets; i++){ //assign unique ID to each net
		nets[i]->n->id = i;
		//printf("Hello %d %d,addr = %d \n", nets[i]->n->net_name, nets[i]->n->id, nets[i]->n);
	}

	/*for(int i=0; i<lineNumber_src; i++) {
		sourceArray[i].voltageID = i;
	}*/
	

	for(int i=0; i<lineNumber; i++) {
		Component comp = componentArray[i];
		Net* net1 = comp.net1;
		Net* net2 = comp.net2;
		for(int p=0; p<number_of_nets; p++) {
			if(net1->net_name == nets[p]->n->net_name)
				comp.net1->id = nets[p]->n->id;
			if(net2->net_name == nets[p]->n->net_name)
				comp.net2->id = nets[p]->n->id;
		}
	}

	for(int i=0; i<lineNumber_src; i++) {
		Source source = sourceArray[i];
		Net* net1 = source.net1;
		Net* net2 = source.net2;
		for(int p=0; p<number_of_nets; p++) {
			if(net1->net_name == nets[p]->n->net_name)
				source.net1->id = nets[p]->n->id;
			if(net2->net_name == nets[p]->n->net_name)
				source.net2->id = nets[p]->n->id;
		}
	}
	
	int zeroid = -1;
	int last;
	int current_row=0;
	for(int i=0; i<number_of_nets; i++) {

		for(int i=0; i<number_of_nets+number_of_voltSources; i++) {
		for(int j=0; j<number_of_nets+number_of_voltSources; j++) {
			printf("%lf+i%lf   ", creal(G[i][j]), cimag(G[i][j]));
		}
		printf(" = %lf\n", curr[i]);
	}
	printf("\n");
		Net2* current_net = nets[i];
		int current_net_id = current_net->n->id;
		int current_net_name = current_net->n->net_name;
		printf("id, name, row = %d, %d, %d\n", current_net_id, current_net_name, current_row);

		
		if(current_net_name == -1){
			zeroid = current_net_id;
			zeroflag = 1;
		}
		else{
			if(current_net_id == 0 && zeroflag == -2)
				zeroid = current_net_id;
		}
		
		int flag=0;

		for(int s=0; s<current_net->count_of_sources; s++){
			Source* source = nets[i]->source_list[s];
			//printf("A: %s %d %d \n", source->identifier, source->net1->id, source->net2->id);
			int other_net_id;

			if(source->net1->id == current_net_id){
				other_net_id = source->net2->id;
			}
			else {
				other_net_id = source->net1->id;
			}
			printf("cid1 = %d, cid2 = %d, oid = %d\n", source->net1->id, source->net2->id, other_net_id);

			//printf("%s %lf %lf Freq difference = %lf\n", source->identifier, source->frequency*2.0*M_PI, freq, fabs(source->frequency*2.0*M_PI - freq));


			if(source->identifier[0]=='V') {
				
				Net2* current_net2 = findNetByID(current_net_id, number_of_nets);
				//printf("Net2=%d", current_net2->n->net_name);
			  if(current_net2->stay_away_flag!=1){
			  		

					G[current_row][current_net_id] = 1.0 + 0.0 * I;
					G[current_row][other_net_id] = -1.0 + 0.0 * I;
					printf("HAHA %d, %d, %d, %lf + i*%lf\n", i, current_row, current_net_id, creal(G[current_row][current_net_id]), cimag(G[current_row][other_net_id]));
					current_net2->visited_flag = 1;
					findNetByID(other_net_id, number_of_nets)->stay_away_flag = 1;
				
				
				
				if(current_net_name == source->net1->net_name){
					if(fabs(source->frequency * 2.0*M_PI - freq) < 0.05)
						curr[i] -= (source->amplitude*cos(source->delay) - source->amplitude*sin(source->delay)*I);
					else
						curr[i] = 0;
				}
				else{
					if(fabs(source->frequency * 2.0*M_PI - freq) < 0.05)
						curr[i] += (source->amplitude*cos(source->delay) - source->amplitude*sin(source->delay)*I);
					else
						curr[i] = 0;
				}
				current_row++;
				flag = 1;
				continue;
			  }
			  else{
			  	printf("Skipped net %d %d\n", current_net2->n->id, current_net2->n->net_name);
			  	//current_row++; //MASSIVE TODO
			  	flag = 1;
			  	break;
			  }
				
			}
			else {
				
				if(current_net_name == source->net1->net_name){ 
					if(fabs(source->frequency * 2.0*M_PI- freq) < 0.05)
						curr[i] -=(source->amplitude*cos(source->delay) - source->amplitude*sin(source->delay)*I);
					else
						curr[i] = 0;
				}
				else{
					if(fabs(source->frequency * 2.0*M_PI - freq) < 0.05)
						curr[i] += (source->amplitude*cos(source->delay) - source->amplitude*sin(source->delay)*I);
					else
						curr[i] = 0;
				}
			}

		}

		if(flag==1)  //HERE IS THE FLAW
			continue;


		for(int c=0; c<current_net->count_of_components; c++){
			Component* comp = nets[i]->comp_list[c];
			//printf("B: %s %d %d\n", comp->identifier, comp->net1->id, comp->net2->id);
			int other_net_id;

			if(comp->net1->id == current_net_id){
				other_net_id = comp->net2->id;
			}
			else {
				other_net_id = comp->net1->id;
			}
			printf("%s coid= %d\n", comp->identifier, other_net_id);
			//printf("%d %d ", i, current_net_id);
			//printf(" %d\n", other_net_id);
			//printf("whattt %lf %c\n",comp->value,comp->identifier[0]);
			if(comp->identifier[0]=='L'){
				G[current_row][current_net_id] -= 0.0 + (1/(freq*comp->value)) * I;
				G[current_row][other_net_id] += 0.0 + (1/(freq*comp->value)) * I;
			}
			else if(comp->identifier[0] == 'R') {
				G[current_row][current_net_id] += (1/comp->value) + 0.0 * I;
				G[current_row][other_net_id] -= (1/comp->value) + 0.0 * I;
			}
			else { //for component name C
				G[current_row][current_net_id] += 0.0 + ((freq)*(comp->value)) * I;
				G[current_row][other_net_id] -= 0.0 + ((freq)*(comp->value)) * I;
			}

		}
	current_row++;
	}

	last=0;
	for(int i=0; i<number_of_nets + number_of_voltSources; i++) {
		for(int j=0; j<number_of_nets + number_of_voltSources; j++) {
			if(cabs(G[i][j]) > 0.0000005) {
				last++;
				break;
			}
		}
	}


	printf("last%d", last);
	for(int i=0; i<number_of_nets; i++){
		G[last][i] = 0.0 + 0.0 * I;
	}

	G[last][zeroid] = 1.0 + 0.0*I;
	curr[last] = 0.0;
	last++;
	//printf("Last = %d", last);

	
//CURRENT VARIABLES
	for(int i=0, c=0; i<number_of_nets; i++) {
		Net2* net2 = nets[i];




		if(net2->visited_flag==1 && net2->stay_away_flag!=1) {


			for(int j=0; j<net2->count_of_sources; j++) {

				Source* source_ptr = net2->source_list[j];
				//printf("Vid: %d \n", source_ptr->voltageID);
				if(source_ptr->identifier[1] = 'V') {
					printf("id, name = %d, %d, %d\n", net2->n->id, net2->n->net_name,source_ptr->voltageID);
					if(source_ptr->net1->id == net2->n->id){
						G[last + c][source_ptr->voltageID + number_of_nets] = 1.0 + 0.0*I; //DECIDE COLUMN _ USE ANOTHER ID?
					}
					else{
						G[last + c][source_ptr->voltageID + number_of_nets] = -1.0 + 0.0*I; 
					}
				}
				else {
					if(source_ptr->net1->id == net2->n->id){
						curr[last + c] -= source_ptr->amplitude + 0.0*I; //DECIDE COLUMN _ USE ANOTHER ID?
					}
					else{
						curr[last + c] += source_ptr->amplitude + 0.0*I; 
					}
				}
			}
			for(int j=0; j<net2->count_of_components; j++) {
				Component* comp = net2->comp_list[j];
				int current_net_id = net2->n->id;
				int other_net_id;
				if(comp->net1->id == current_net_id){
					other_net_id = comp->net2->id;
				}
				else {
					other_net_id = comp->net1->id;
				}
				//printf("%d %d ", i, current_net_id);
				//printf(" %d\n", other_net_id);
				//printf("whattt %lf %c\n",comp->value,comp->identifier[0]);
				if(comp->identifier[0]=='L'){
					G[last + c][current_net_id] -= 0.0 + (1/(freq*comp->value)) * I;
					G[last + c][other_net_id] += 0.0 + (1/(freq*comp->value)) * I;
				}
				else if(comp->identifier[0] == 'R') {
					G[last + c][current_net_id] += (1/comp->value) + 0.0 * I;
					G[last + c][other_net_id] -= (1/comp->value) + 0.0 * I;
				}
				else { //for component name C
					G[last + c][current_net_id] += 0.0 + ((freq)*(comp->value)) * I;
					G[last + c][other_net_id] -= 0.0 + ((freq)*(comp->value)) * I;
				}

			}
			c++;
		}
	}
	for(int i=0; i<number_of_nets+number_of_voltSources; i++) {
		for(int j=0; j<number_of_nets+number_of_voltSources; j++) {
			printf("%lf+i%lf   ", creal(G[i][j]), cimag(G[i][j]));
		}
		printf(" = %lf\n", curr[i]);
	}
	printf("\n");

	//printf("Last = %d", last);

	/*for(int i=0; i<number_of_nets; i++){
		G[iterate][i] = 0.0 + 0.0 * I;
	}

	G[iterate][zeroid] = 1.0 + 0.0*I;
	curr[iterate] = 0.0;*/

	/**/

	int row,col;
    int row1,col1;
    int n=0,i,j,k,p;
    double complex c,d,e,sum;
    

    row= number_of_nets+number_of_voltSources;
    col = number_of_nets+number_of_voltSources;

    if(row <col){
        n = row;}
    else {	n =col;}
// Filling the Matrix

    for(i=0;i<row;i++){
        for(j=0;j<col;j++){
            matrix[i][j] = G[i][j];
           // printf("%lf + i*%lf\t",creal(matrix[i][j]), cimag(matrix[i][j]));

        }
        //printf("\n");
    }
    
// Filling Augmented Matrix

    //fscanf(file_ptr1,"%d \t",&row1);
    //fscanf(file_ptr1,"%d \t",&col1);

    for(i=0;i<row;i++){
        matrix[i][col] = curr[i] + 0.0 * I;
        //fscanf(file_ptr1,"%g\t",&matrix[i][col]);
    }

   

//Making Upper Triangular Matrix
    for(k=0;k<n;k++)
    {

//Pivoting

        complex double a= matrix[k][k];
        complex double temp=0.0 + 0.0 * I;
        int ind=k,l,m;
        for(l=k+1;l<n;l++)
        {
            if(cabs(a) <cabs(matrix[l][k])){
                a= matrix[l][k];
                ind = l;

            }
            else continue;


            for(m=0;m<n+1;m++){
                temp = matrix[k][m];
                matrix[k][m] = matrix[ind][m];
                matrix[ind][m] = temp;

            }
        }


        for(i=k+1;i<n;i++){
            c = (matrix[i][k] / matrix[k][k] ) ;

            for(j=k;j<n+1;j++){
                matrix[i][j] = matrix[i][j] -  c * matrix[k][j] ;



                if(cabs(matrix[i][j]) < 0.0000005){
                    matrix[i][j] = 0.0 + 0.0 * I;
                }
            }
        }
    } 


// Findind the rank of the Matrix
    int count,count1,zerorows=0,aug_non_zero =0;
    for(i=0;i<row;i++){
        count = 0;
        for(j=0;j<col;j++){
            if(cabs(matrix[i][j]) < 0.0000005)
                count +=1;
        }

        for(j=0;j<col+1;j++){
            if(cabs(matrix[i][j]) < 0.0000005)
                count1 +=1;
        }



        if(count == n){ zerorows +=1 ;}
        else if (count1 == n+1 ) {aug_non_zero +=1 ;}
    }

    int rankA,rankAB;

    rankA = row - zerorows;
    rankAB = row - aug_non_zero;

    printf("ra%d rab%d\n", rankA, rankAB);

//Checking the Solution
    if (rankA == rankAB && rankA == col){
        printf("Unique Solution Exists when removing row %d\n", iterate);

//Back Substitution
        var[n-1] = matrix[n-1][n] /matrix[n-1][n-1];
        for(i=0;i<n;i++){
            sum = 0.0 + 0.0 * I;

            for(j=0;j<i;j++){
                b= var[n-j-1];
                a = matrix[n-i-1][n-j-1];
                sum = sum +  a*b  ;
            }
            var[n-i-1] = (matrix[n-i-1][n] - sum)/ matrix[n-i-1][n-i-1] ;
        }

        for(i=0;i<n;i++){
            printf("X[%d] -> %lf + i*%lf\n",i+1,creal(var[i]), cimag(var[i]));
        }
        break;
    }
    else{printf("No Finite Solution Exists when removing row %d\n", iterate);}

  }

  for(int i=0; i<number_of_nets; i++) {
  	nets[i]->n->voltage = var[nets[i]->n->id];
  }
  for(int i=0; i<lineNumber_src; i++) {
  	if(sourceArray[i].identifier[1] =='V'){
  		sourceArray[i].current = var[number_of_nets + i];
  	}
  }

  
  fprintf(fptr2, "VOLTAGES\n");

  for(int source_pointer=0,  comp_pointer=0, i = 0; i<lineNumber_total; i++){
  	Source source;
  	Component comp;
  	//printf("Pleaseeeee %d %d\n",sourceArray[source_pointer].elementid,componentArray[comp_pointer].elementid);
  	if((sourceArray[source_pointer].elementid == i)){
  		source = sourceArray[source_pointer];
  		fprintf(fptr2, "%s %.3f %.3f\n", (source.identifier)+1, cabs((findNetByID(source.net1->id, number_of_nets))->n->voltage - (findNetByID(source.net2->id, number_of_nets))->n->voltage), carg((findNetByID(source.net2->id, number_of_nets))->n->voltage - (findNetByID(source.net1->id, number_of_nets))->n->voltage)*180.0/M_PI);
  		source_pointer++;
  		
  	}
  	else if(componentArray[comp_pointer].elementid == i) {
  		comp = componentArray[comp_pointer];
  		fprintf(fptr2, "%s %.3f %.3f\n", (comp.identifier)+1, cabs((findNetByID(comp.net1->id, number_of_nets))->n->voltage - (findNetByID(comp.net2->id, number_of_nets))->n->voltage), carg((findNetByID(comp.net1->id, number_of_nets))->n->voltage - (findNetByID(comp.net2->id, number_of_nets))->n->voltage)*180.0/M_PI);
  		comp_pointer++;
  		
  	} //TODO
  }

  fprintf(fptr2, "\nCURRENTS\n");

  
  for(int source_pointer=0,  comp_pointer=0, i = 0; i<lineNumber_total; i++){
  	Source source;
  	Component comp;
  	//printf("Pleaseeeee %d %d\n",sourceArray[source_pointer].elementid,componentArray[comp_pointer].elementid);
  	if((sourceArray[source_pointer].elementid == i)){
  		source = sourceArray[source_pointer];
  		if(source.identifier[1] == 'V') 
  			fprintf(fptr2, "%s %.3f %.3f\n", source.identifier+1, cabs(source.current), carg(source.current)*180.0/M_PI); //TID
  		else
  			fprintf(fptr2, "%s %.3f %.3f\n", (source.identifier)+1, source.amplitude, -source.delay*source.frequency*2*M_PI);
  		source_pointer++;
  		
  	}
  	else if(componentArray[comp_pointer].elementid == i) {
  		comp = componentArray[comp_pointer];
  		double complex impedance;
  				if(comp.identifier[0]=='L'){
					impedance = 0.0 + ((freq*comp.value)) * I;
				}
				else if(comp.identifier[0] == 'R') {
					impedance = comp.value + 0.0 * I;
				}
				else { //for component name C
					impedance = 0.0 + (1/((freq)*(comp.value))) * I;
				}
		double complex current =(findNetByID(comp.net1->id, number_of_nets)->n->voltage - findNetByID(comp.net2->id, number_of_nets)->n->voltage)/impedance;
		fprintf(fptr2, "%s %.3f %.3f\n", comp.identifier+1, cabs(current), carg(current) * 180.0/M_PI);
  		comp_pointer++;
  		
  	} //TODO
  }

  fprintf(fptr2,"\n\n");



}

/*Source* findSourceByID(int id, int lineNumber_src){
	for(int i=0; i<lineNumber_src; i++) {
		Source source = sourceArray[i];
		if(source.voltageID == id)
			return &sourceArray[i];
	}
}*/

Net2* findNetByID(int id, int number_of_nets){
	for(int i=0; i<number_of_nets; i++) {
		if(nets[i]->n->id == id)
			return nets[i];
	}
}



void printSource(Source *source, FILE *fptr, double xCordreqd, double yCordreqd) {

    char* type = source->identifier;
    switch(type[0]) {
        case 'V':
            fprintf(fptr, "<g\n"
                    "     id=\"g4164\"\n"
                    "     transform=\"translate(%lf,%lf)\">\n"
                    "    <path\n"
                    "       sodipodi:nodetypes=\"czzzc\"\n"
                    "       inkscape:connector-curvature=\"0\"\n"
                    "       id=\"path5536-8-3\"\n"
                    "       d=\"m 0.3478974,9.7865691 c 0.67934,2.0380199 2.07525,4.0760499 4.09466,4.0760499 2.01941,0 3.3781,-2.03803 4.05744,-4.0760499 0.6793396,-2.03803 2.0380296,-4.07605 4.0760496,-4.07605 2.03803,0 3.39671,2.03802 4.07605,4.07605\"\n"
                    "       style=\"fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1\" />\n"
                    "    <circle\n"
                    "       r=\"10\"\n"
                    "       cy=\"9.7865725\"\n"
                    "       cx=\"8.4999971\"\n"
                    "       id=\"path14021-7-1-7\"\n"
                    "       style=\"color:#000000;clip-rule:nonzero;display:inline;overflow:visible;visibility:visible;opacity:1;isolation:auto;mix-blend-mode:normal;color-interpolation:sRGB;color-interpolation-filters:linearRGB;solid-color:#000000;solid-opacity:1;fill:none;fill-opacity:1;fill-rule:nonzero;stroke:#000000;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;marker:none;color-rendering:auto;image-rendering:auto;shape-rendering:auto;text-rendering:auto;enable-background:accumulate\" />\n"
                    "\t   <text x=\" 4\" y=\"-7\" font-size=\"8\" fill=\"black\" >\n"
                    "\t\tSINE %s\n"
                    "\t</text>\n"
                    "\t<text x=\"4\" y=\"30\" font-size=\"8\" fill=\"black\" >\n"
                    "\t\t(%g %g %g %g %g)\n"
                    "\t</text>\n"
                    "  </g>\n",xCordreqd-10, yCordreqd, type, source->dc_offset
                            , source-> amplitude, source->frequency, source->delay, source ->damping_factor); //<DC Offset> <Amplitude> <Frequency> <Delay> <Damping Factor>)
            break;
        case 'I':
            fprintf(fptr, " <g  transform=\"translate(%lf,%lf)\">\n"
                    "  <g\n"
                    "     id=\"layer1\" >\n"
                    "\t \n"
                    "    <path\n"
                    "       d=\"M 25,35.04878 L 25,17\"\n"
                    "       style=\"fill:none;fill-opacity:0.75;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\"\n"
                    "       id=\"path1309\" />\n"
                    "    <path\n"
                    "       d=\"M 25,15.5 L 27,18.5 L 23,18.5 L 25,15.5 z \"\n"
                    "       style=\"fill:#000000;fill-opacity:1;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\"\n"
                    "       id=\"path1311\" />\n"
                    "    <path\n"
                    "       d=\"M 40,25 C 40,33.284271 33.284271,40 25,40 C 16.715729,40 10,33.284271 10,25 C 10,16.715729 16.715729,10 25,10 C 33.284271,10 40,16.715729 40,25 L 40,25 z \"\n"
                    "       style=\"opacity:1;fill:none;fill-opacity:1;stroke:#000000;stroke-width:1;stroke-linecap:square;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1\"\n"
                    "       id=\"path1319\" />\n"
                    "\t   <text x=\" 19\" y=\"4\" font-size=\"8\" fill=\"black\" >\n"
                    "\t\tI %s\n"
                    "\t</text>\n"
                    "\t<text x=\"4\" y=\"50\" font-size=\"8\" fill=\"black\" >\n"
                    "\t\t(%g %g %g %g %g)\n"
                    "\t</text>\n"
                    "  </g>\n"
                    "  </g>",xCordreqd-15, yCordreqd-9, type  + sizeof(char), source->dc_offset
                    , source-> amplitude, source->frequency, source->delay, source ->damping_factor);
            break;
        default:
            break;
    }
}
void printComponent(Component *component, FILE *fptr, double xCordreqd, double yCordreqd){

    char* type = component->identifier;
    switch(type[0]) {

        case 'R' :
            fprintf(fptr,
                        " <g transform =\"translate(%lf,%lf)\" >\n"
                                "  <g\n"
                                "     inkscape:label=\"Layer 1\"\n"
                                "     inkscape:groupmode=\"layer\"\n"
                                "     id=\"layer1\"\n"
                                "     transform=\"scale(0.4)translate(-350.12512,-540.87206)\">\n"
                                "    <g\n"
                                "       id=\"g3359\"\n"
                                "       transform=\"translate(-0.48334,-1.2626907)\">\n"
                                "      <path\n"
                                "         id=\"path2160\"\n"
                                "         d=\"M 351.35169,548.62453 L 371.26473,548.62453\"\n"
                                "         style=\"fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:2.9729352;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1\" />\n"
                                "      <path\n"
                                "         id=\"path3149\"\n"
                                "         d=\"M 430.17601,548.62453 L 449.3819,548.62453\"\n"
                                "         style=\"fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:2.9729352;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1\" />\n"
                                "      <path\n"
                                "         sodipodi:nodetypes=\"ccccccccc\"\n"
                                "         id=\"path3344\"\n"
                                "         d=\"M 370.62756,548.90283 L 374.96171,544.32858 L 383.56813,552.98228 L 392.30206,544.39042 L 401.22724,553.04409 L 409.64241,544.45221 L 417.93009,553.1059 L 427.04651,544.14316 L 430.87067,548.96478\"\n"
                                "         style=\"fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:2.98287892;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1\" />\n"
                                "\t\t <text x=\"400\" y=\"530\" font-size=\"24\" fill=\"black\" >\n"
                                "\t\t%s\n"
                                "\t\t</text>\n"
                                "\t\t<text x=\"400\" y=\"580\" font-size=\"24\" fill=\"black\" >\n"
                                "\t\t%g Ohm\n"
                                "\t\t</text>\n"
                                "    </g>\n"
                                "   </g>\n"
                                "   </g>"

                    ,xCordreqd-18.5, yCordreqd-3, type + sizeof(char), component->value);
            break;

        case 'L' :
            fprintf(fptr, " <g transform=\"translate(%lf,%lf)\">\n"
                    "  <path\n"
                    "     style=\"fill:none;fill-opacity:0.75;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\"\n"
                    "     d=\"M 1,8.5 L 6.5,8.5 C 6.5,8.5 6.5,4.5 10.5,4.5 C 14.5,4.5 14.5,8.5 14.5,8.5 C 14.5,8.5 14.5,4.5 18.5,4.5 C 22.5,4.5 22.5,8.5 22.5,8.5 C 22.5,8.5 22.5,4.5 26.5,4.5 C 30.5,4.5 30.5,8.5 30.5,8.5 C 30.5,8.5 30.5,4.5 34.5,4.5 C 38.5,4.5 38.5,8.5 38.5,8.5 L 44,8.5\"\n"
                    "     id=\"path1318\"\n"
                    "     sodipodi:nodetypes=\"ccscscscscc\" />\n"
                    "\t <text x=\"22\" y=\"2\" font-size=\"8\" fill=\"black\" >\n"
                    "\t\t%s\n"
                    "\t</text>\n"
                    "\t<text x=\"22\" y=\"18\" font-size=\"8\" fill=\"black\" >\n"
                    "\t\t%g H\n"
                    "\t</text>\n"
                    "\t </g>",xCordreqd-21.5, yCordreqd-10, type + sizeof(char), component->value);
            break;

        case 'C' :
            fprintf(fptr, "   <g transform=\"translate(%lf,%lf)\">\n"
                    "  <g\n"
                    "     id=\"layer1\">\n"
                    "    <path\n"
                    "       d=\"M 16,5.0010577 C 16,26.999992 16,26.999992 16,26.999992\"\n"
                    "       style=\"fill:none;fill-opacity:0.75;fill-rule:evenodd;stroke:#000000;stroke-width:1.5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1\"\n"
                    "       id=\"path17478\" />\n"
                    "    <path\n"
                    "       d=\"M 19.000016,26.999994 L 19.000016,5.0010588\"\n"
                    "       style=\"fill:none;fill-opacity:0.75;fill-rule:evenodd;stroke:#000000;stroke-width:1.5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1\"\n"
                    "       id=\"path17480\" />\n"
                    "    <path\n"
                    "       d=\"M 16.11348,16 L 1.69e-005,16\"\n"
                    "       style=\"fill:none;fill-opacity:0.75;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\"\n"
                    "       id=\"path17482\" />\n"
                    "    <path\n"
                    "       d=\"M 18.980533,16 C 19.743365,16 35,16 35,16\"\n"
                    "       style=\"fill:none;fill-opacity:0.75;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\"\n"
                    "       id=\"path17484\" />\n"
                    "\t <text x=\"13\" y=\"3\" font-size=\"8\" fill=\"black\" >\n"
                    "\t\t%s\n"
                    "\t</text>\n"
                    "\t<text x=\"13\" y=\"33\" font-size=\"8\" fill=\"black\" >\n"
                    "\t\t%g F\n"
                    "\t</text>\n"
                    "  </g>\n"
                    "  </g>",xCordreqd-17.5, yCordreqd-10.5, type +sizeof(char), component->value);
            break;

        default:
            break;
    }
}
