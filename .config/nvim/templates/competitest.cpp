// Problem: $(PROBLEM)
// Contest: $(CONTEST)
// Judge: $(JUDGE)
// URL: $(URL)
// Memory Limit: $(MEMLIM)
// Time Limit: $(TIMELIM)
// Start: $(DATE)

#include <bits/stdc++.h>
using namespace std;

/* clang-format off */

#define ll long long
#define PI 3.1415926535897932384626433832795

long long min(ll a,int b) { if (a<b) return a; return b; }
long long min(int a,ll b) { if (a<b) return a; return b; }
long long max(ll a,int b) { if (a>b) return a; return b; }
long long max(int a,ll b) { if (a>b) return a; return b; }
long long gcd(ll a,ll b) { if (b==0) return a; return gcd(b, a%b); }
long long lcm(ll a,ll b) { return a/gcd(a,b)*b; }
string to_upper(string a) { for (int i=0;i<(int)a.size();++i) if (a[i]>='a' && a[i]<='z') a[i]-='a'-'A'; return a; }
string to_lower(string a) { for (int i=0;i<(int)a.size();++i) if (a[i]>='A' && a[i]<='Z') a[i]+='a'-'A'; return a; }
bool prime(ll a) { if (a==1) return 0; for (int i=2;i<=round(sqrt(a));++i) if (a%i==0) return 0; return 1; }

/*  All Required define Pre-Processors and typedef Constants */
typedef long int int32;
typedef unsigned long int uint32;
typedef long long int int64;
typedef unsigned long long int  uint64;

/* clang-format on */

int
main ()
{
    return 0;
}
