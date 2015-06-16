package main
import (
	"github.com/lankecheng/polyge/server/pgpub"
	"time"
	"strconv"
	"math/rand"
	"fmt"
)

func main() {
	now := time.Now()
	oauthToken := strconv.FormatInt(now.Unix(), 10)

	rand.Seed(now.UnixNano())
	oauthToken += strconv.Itoa(rand.Int())
	oauthToken += strconv.Itoa(888)

	if len(oauthToken) < 32 {
		oauthToken += pgpub.RepeatChar("0", "", 32-len(oauthToken))
	} else if len(oauthToken) > 32 {
		oauthToken = oauthToken[0:32]
	}
	fmt.Println(oauthToken)
}
