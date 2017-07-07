#include <stdio.h>
#include <string.h>
#include <complex.h>
#define PIXEL_Y 40.0

typedef struct {
    double xCord;
    double yCord;
    int net_name;
    double complex voltage;
    int id; //stores the voltage at that terminal
}Net;


typedef struct {
    char* identifier; // 'R' or 'C' or 'L' followed by number, e.g. 'R12
    Net* net1;
    Net* net2; //ground by -1
    double value;
    double xPlace; //where this is placed in the final SVG
    double yPlace;
    int elementid;  
}Component;


typedef struct {
    char* identifier; // 'V' or 'I' followed by number, e.g. 'R12
    Net* net1;
    Net* net2; //ground by -1
    double dc_offset;
    double amplitude;
    double frequency;
    double delay;
    double damping_factor;
    double xPlace;
    double yPlace;
    int elementid;
    int voltageID;
    double complex current;
}Source;

typedef struct 
{
    Net* n;
    Source* source_list[100];
    Component* comp_list[100]; 
    Net* adjacent_list[100];
    int count_of_sources;
    int count_of_components;
    int count_of_adjacent_lists;
    int visited_flag; 
    int stay_away_flag;
}Net2;

typedef struct
{
    double real;
    double imaginary;
}Complex;

Component* componentArray;
Source* sourceArray;
int lineNumber_src=0;
int lineNumber=0;
int lineNumber_total=0;
Net2* nets[100];
int number_of_nets=0;
int net_id=0;
int zeroflag = -2;
int number_of_voltSources=0;

void printSource(Source *source, FILE *fptr, double xCordreqd, double yCordreqd);
void printComponent(Component *component, FILE *fptr, double xCordreqd, double yCordreqd);
void solveCircuit(int number_of_nets,FILE *fptr, int num_components, int num_sources, double freq, FILE* fptr2);
Net2* findNetByID(int id, int number_of_nets);
