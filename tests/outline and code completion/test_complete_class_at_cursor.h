#ifndef _MAIN_H_
#define _MAIN_H_

namespace NameSpace
{
	namespace InternalNameSpace
	{
		class Test
		{
		private:
			int a;
		protected:
			int* protected_function(char* param1, int param2);
			virtual int* protected_function_virt(char* param1, int param2);
			virtual int* protected_function_pure_virt(char* param1, int param2) = 0;
		public:
			void* public_function(char* param1, int param2);
		};
	}
}
#endif /* _MAIN_H_ */
