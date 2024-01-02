import * as dotenv from 'dotenv'
import * as dotenvExpand from 'dotenv-expand'
import { execSync } from 'child_process'
import sharp from 'sharp'

const myEnv = dotenv.config()
dotenvExpand.expand(myEnv)

const assetsDir = process.env.ASSET_DIR
const outputsDir = process.env.EPUB_IMAGE_DIR
const imageExtension = process.env.IMAGE_EXTENSION

const stdout = execSync(`\\ls ${assetsDir} -A`)
const fileList = stdout.toString().split('\n')

const startNumber = 1
let count = 0

const left = parseInt(process.env.TRIM_LEFT, 10)
const top = parseInt(process.env.TRIM_TOP, 10)
const width = parseInt(process.env.IMAGE_WIDTH, 10)
const height = parseInt(process.env.IMAGE_HEIGHT, 10)
const coverLeft = parseInt(process.env.COVER_TRIM_LEFT, 10)
const coverTop = parseInt(process.env.COVER_TRIM_TOP, 10)
const coverWidth = parseInt(process.env.COVER_IMAGE_WIDTH, 10)
const coverHeight = parseInt(process.env.COVER_IMAGE_HEIGHT, 10)

const imageExtractor = function (input, output, left, top, width, height, outputFileName) {
  sharp(input)
    .extract({
      left,
      top,
      width,
      height,
    })
    .toFile(output)
    .then(() => {
      console.log(`triming '${outputFileName}' succeeded.`)
    })
  console.log(output)
}

const imageResizer = function (input, output, width, height, fileName) {
  sharp(input)
    .resize({
      width,
      height,
      fit: 'fill',
    })
    .toFile(output)
    .then(() => {
      console.log(`resizing '${fileName}' succeeded.`)
    })
  console.log(output)
}

fileList.forEach((data) => {
  const input = `${assetsDir}/${data}`
  if (data.endsWith(`cover.${imageExtension}`) && process.env.COVER_TRIM_FLAG) {
    const outputCoverName = `cover.${imageExtension}`
    const output = `${outputsDir}/${outputCoverName}`

    imageExtractor(input, output, coverLeft, coverTop, coverWidth, coverHeight, outputCoverName)
    imageResizer(input, output, width, height, data)
  } else if (
    data.endsWith(`.${imageExtension}`) &&
    !data.endsWith(`cover.${imageExtension}`) &&
    !data.startsWith(`page`)
  ) {
    const targetNumber = ('0000' + (startNumber + count)).slice(-4)
    const outputFileName = `page${targetNumber}.${imageExtension}`
    const output = `${outputsDir}/${outputFileName}`

    imageExtractor(input, output, left, top, width, height, outputFileName)

    count++
  } else if (data.startsWith(`page`)) {
    // pageで始まるファイルはすでにトリミング済みなので、リサイズのみ実行して出力フォルダに保存
    const output = `${outputsDir}/${data}`
    imageResizer(input, output, width, height, data)
  }
})

console.log(`exit function: '${count}' images are processed.`)
