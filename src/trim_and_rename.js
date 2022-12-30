import * as dotenv from 'dotenv'
import * as dotenvExpand from 'dotenv-expand'
import { execSync } from 'child_process'
import sharp from 'sharp'

const myEnv = dotenv.config()
dotenvExpand.expand(myEnv)

const assetsDir = process.env.ASSET_DIR
const outputsDir = process.env.EPUB_IMAGE_DIR
const imageExtension = process.env.IMAGE_EXTENSION

const stdout = execSync(`ls ${assetsDir}`)
const fileList = stdout.toString().split('\n')

const startNumber = 1
let count = 0

const left = parseInt(process.env.TRIM_LEFT, 10)
const top = parseInt(process.env.TRIM_TOP, 10)
const width = parseInt(process.env.IMAGE_WIDTH, 10)
const height = parseInt(process.env.IMAGE_HEIGHT, 10)

fileList.forEach((data) => {
  if (data.endsWith(`.${imageExtension}`) && !data.endsWith(`cover.${imageExtension}`)) {
    const input = `${assetsDir}/${data}`
    const targetNumber = ('0000' + (startNumber + count)).slice(-4)
    const outputFileName = `page${targetNumber}.${imageExtension}`
    const output = `${outputsDir}/${outputFileName}`

    sharp(input)
      .resize({
        width,
        height,
        fit: 'outside',
      })
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

    count++
  }
})

console.log(`exit function: '${count}' images are processed.`)
