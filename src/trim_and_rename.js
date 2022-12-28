import * as dotenv from 'dotenv'
import * as dotenvExpand from 'dotenv-expand'
import { execSync } from 'child_process'
import sharp from 'sharp'

const myEnv = dotenv.config()
dotenvExpand.expand(myEnv)

const assetsDir = process.env.ASSET_DIR
const outputsDir = process.env.EPUB_IMAGE_DIR

const stdout = execSync(`ls ${assetsDir}`)
const fileList = stdout.toString().split('\n')

const startNumber = 1
let count = 0

const left = parseInt(process.env.TRIM_LEFT, 10)
const top = parseInt(process.env.TRIM_TOP, 10)
const width = parseInt(process.env.IMAGE_WIDTH, 10)
const height = parseInt(process.env.IMAGE_HEIGHT, 10)

fileList.forEach((data) => {
  if (data.endsWith('.jpg') && !data.endsWith('cover.jpg')) {
    const input = `${assetsDir}/${data}`
    const filename = input.replace('.jpg', '')
    const targetNumber = ('0000' + (startNumber + count)).slice(-4)
    const output = `${outputsDir}/${input.replace(filename, 'page' + targetNumber)}`

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
        console.log(`triming '${output}' succeeded.`)
      })

    count++
  }
})

console.log(`exit function: '${count}' images are processed.`)
