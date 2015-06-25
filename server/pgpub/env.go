package pgpub

import (
	"path"
	//	"os/exec"
	"os"
	//	"path/filepath"
	//	"strings"
	"fmt"
	"os/exec"
	"path/filepath"
	"strings"
)

/**
程序部署结构需要讨论，早上简单讨论了一下，部署结构类似

./
   bin/
   conf/
   logs/

   GoMain places at /bin
*/
const (
	//bin目录
	BinFolderName = "bin"
	//config目录
	ConfigFolderName = "conf"
	LogsFolderName   = "logs"
)

var (
	ExecutablePath  string // 可执行文件的路径
	ApplicationPath string // 整个程序结构的根路径
	ConfPath        string // conf路径
	LogsPath        string //logs路径
)

func init() {
	execPath, err := exec.LookPath(os.Args[0])
	if err != nil {
		fmt.Println(err)
	}
	ExecutablePath, err = filepath.Abs(execPath)

	//如果是在temp目录下运行，说明是用go run运行，直接用 ./ 来作为 ApplicationPath
	if strings.HasPrefix(ExecutablePath, os.TempDir()) {
		ApplicationPath, err = filepath.Abs("./")
		if err != nil {
			fmt.Println(err)
		}
	} else {
		ApplicationPath = path.Dir(ExecutablePath)
	}
	//有两种运行启动方式
	//1. 开发时会用 go build 编译生成可执行文件，这时候一般为了方便起见是直接执行可执行文件的，只需尝试一次即可拿到conf目录
	//2. 在正式部署后，可执行文件会放在 ./bin/下面，所以要拿到conf，需要尝试两次
	// 额外好处就是假设有 ./atlas-check和 ./atlas-dump 开发时需要共享相同的目录。开发环境中，就可以把conf目录放在./conf共享
	// 当然，也可以不设置只尝试两次，可以一级一级网上尝试有没有conf目录，但是好像也不是太符合日常场景，先不考虑这样做。
	for i := 0; i < 2; i++ {
		ConfPath = path.Join(ApplicationPath, ConfigFolderName)
		LogsPath = path.Join(ApplicationPath, LogsFolderName)
		if exists, _ := IsFileExist(ConfPath); exists == true {
			break
		} else {
			ApplicationPath = path.Dir(ApplicationPath)
		}
	}
}
