#include<cstdio>
#include<queue>
#include<fstream>
#include<iostream>

int main()
{
    std::ifstream in("line.in");
    std::cin.rdbuf(in.rdbuf());

    int dirx[4]={1, 0, -1, 0};
    int diry[4]={0, 1, 0, -1};

    int m, n, text_size;
    std::cin >> m >> n >> text_size;
    //std::cout << m << n;
    int **img = new int*[m];
    for(int i=0;i<m;++i) img[i]=new int[n];

    int **output = new int*[m];
    for(int i=0;i<m;++i) output[i]=new int[n];
    for(int i=0;i<m;++i){
        for(int j=0;j<n;++j){
            output[i][j]=0;
        }
    }

    for(int j=0;j<n;++j){
        for(int i=0;i<m;++i){
            std::cin >> img[i][j];
        }
    }

    double a1, b1, a2, b2;
    std::queue<int> qx, qy;
    std::cout << m << " " << n << "\n";
    for(int j=0;j<n;++j){
        for(int i=0;i<m;++i){
            if(img[i][j]==1){
                std::cout << i << " " << j << "\n";
                a1=i; b1=j; a2=0; b2=0;
                while(!qx.empty()) qx.pop();
                while(!qy.empty()) qy.pop();
                qx.push(i); qy.push(j);
                while(!qx.empty() && !qy.empty()){
                    int x=qx.front(), y=qy.front();
                    qx.pop(); qy.pop();
                    for(int k=0;k<4;++k){
                        int xt=x+dirx[k], yt=y+diry[k];
                        if(xt>=0 && xt<m && yt>=0 && yt<n){
                            if(img[xt][yt]==1){
                                qx.push(xt); qy.push(yt);
                                img[xt][yt]=0;
                                if(yt>b2){
                                    b2=yt; a2=xt;
                                }
                            }
                        }
                    }
                }
                int a=0;
                if(b1==b2)b2++;
                std::cout << a2 << " " << b2 << "\n";
                int amax=std::max(a1, a2), amin=std::min(a1, a2);
                for(double ii=amin;ii<=amax;++ii){
                    for(double jj=b1;jj<=b2;++jj){
                        double temp=(a2-a1)/(b2-b1)*(jj-b1)-(ii-a1);
                        if(temp*((a2-a1)/(b2-b1)*(jj+1-b1)-(ii-a1)) < 0 ||
                           temp*((a2-a1)/(b2-b1)*(jj-b1)-(ii+1-a1)) < 0 ||
                           temp*((a2-a1)/(b2-b1)*(jj+1-b1)-(ii+1-a1)) < 0){
                            ++a;
                            for(int k=0;k<text_size/10;++k) if(ii+k<m)output[int(ii)+k][int(jj)]=1;
                        }
                    }
                }
                std::cout << a << "\n";
            }
        }
    }


    std::ofstream out("line.out");
    if(!out) std::cout << "!";
    //std::cout.rdbuf(out.rdbuf());
    for(int i=0;i<m;++i){
        for(int j=0;j<n;++j){
            if(j!=0) out << " ";
            out << output[i][j];
        }
        out << "\n";
    }
    out.close();
    std::cout << std::flush;
    return 0;
}
