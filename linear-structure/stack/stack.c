#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>

typedef struct MyStack {
    char* elements;
    int nmemb;
    int capacity;
} stack_t;

stack_t* init_stack(int init_cap) {
    stack_t* stack = malloc(sizeof* stack);
    if (stack == NULL)
        return NULL;
    stack->elements = malloc((unsigned long)init_cap * sizeof* stack->elements);
    if (stack->elements == NULL) {
        free(stack);
        return NULL;
    }
    stack->nmemb = 0;
    stack->capacity = init_cap; 
    return stack;
}

bool push(stack_t* stack, char e) {
    if (stack->capacity > stack->nmemb) {
        stack->elements[stack->nmemb] = e;
        stack->nmemb++;
        return true;
    }
    else {
        stack->elements = reallocarray(stack->elements, stack->capacity * 2, sizeof* stack->elements);
        if (stack->elements == NULL) {
            free(stack);
            return false;
        }
    }
    stack->elements[stack->nmemb] = e;
    stack->nmemb++;
    return true;
}   

char pop(stack_t* stack) {
    if (stack->nmemb > 0)
        stack->nmemb--;
    return stack->elements[stack->nmemb + 1];
}

char peek(stack_t* stack) {
    return stack->elements[stack->nmemb];
}

