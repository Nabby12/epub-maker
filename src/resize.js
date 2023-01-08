import * as dotenv from 'dotenv'
import * as dotenvExpand from 'dotenv-expand'
import { execSync } from 'child_process'
import sharp from 'sharp'

const myEnv = dotenv.config()
dotenvExpand.expand(myEnv)

const assetsDir = process.env.ASSET_DIR
const outputsDir = `${assetsDir}/resized/${getCurrentDateString()}`
const makedirStdout = execSync(`mkdir -p ${outputsDir}`)
console.log(makedirStdout)

const stdout = execSync(`ls ${assetsDir}`)
const fileList = stdout.toString().split('\n')

const resizeWidth = parseInt(process.argv[2], 10)
const resizeHeight = parseInt(process.argv[3], 10)
const imageExtension = process.argv[4]

fileList.forEach((data) => {
  if (data.endsWith(`.${imageExtension}`)) {
    const input = `${assetsDir}/${data}`
    const output = `${outputsDir}/${data}`

    sharp(input)
      .resize({
        width: resizeWidth,
        height: resizeHeight,
        fit: 'fill',
      })
      .toFile(output)
      .then(() => {
        console.log(`resizing '${data}' succeeded.`)
      })
  }
})

// 現在の時刻を文字列（YYYYMMDDhhmmss）として取得
function getCurrentDateString() {
  const pad = (n) => (n < 10 ? '0' : '') + n
  const date = new Date()
  const year = date.getFullYear()
  const month = pad(date.getMonth() + 1)
  const day = pad(date.getDate())
  const hours = pad(date.getHours())
  const minutes = pad(date.getMinutes())
  const seconds = pad(date.getSeconds())
  const dateTime = `${year}${month}${day}${hours}${minutes}${seconds}`

  return dateTime
}
