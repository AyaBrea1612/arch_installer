#include<stdio.h>
#include<stdlib.h>

#define max_num 20


//输入一组整数，求出这组数字子序列和的最大值。

int main(int argc ,char **argv)
{
	short num_list[max_num], num_data[max_num];
	short num_geshu = argc - 1;
	short result = 0;

	if (num_geshu > max_num || num_geshu <= 0)
	{
		printf("GG\n");
		return 0;
	}
	for (short k = 0; k <= num_geshu - 1; k ++)
	{
		num_list[k] = atoi(argv[k + 1]);
		printf("%d  ", num_list[k]);
	};
	printf("\n");

	short num_data_key = 0;
	for (short k = 0; k <= num_geshu - 1; k ++)
	{
		if (k == 0)
		{
			num_data[num_data_key] = num_list[0];
		}
		else if((num_data[num_data_key] > 0 && num_list[k] > 0) || (num_data[num_data_key] <= 0 && num_list[k] <= 0))
		{
			num_data[num_data_key] = num_data[num_data_key] + num_list[k];
		}
		else
		{
			num_data_key ++;
			num_data[num_data_key] = num_list[k];
		}
	}

	for (short i = 0; i < num_data_key + 1; ++i)
	{
		int sum = 0;
		for (short j = i; j < num_data_key + 1; ++j)
		{
			sum = sum + num_data[j];
			if (sum > result)
			{
				result = sum;
			}
		}
	}
		
	printf("组数字子序列和的最大值:%d", result);

	return 0;
}
